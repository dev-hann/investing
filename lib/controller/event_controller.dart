import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/model/calendar/calendar_event.dart';
import 'package:investing/use_case/event_use_case.dart';

typedef CalendarEventData = Map<String, List<CalendarEvent>>;

class EventState extends Equatable {
  const EventState({
    required this.dateTime,
    required this.eventType,
    this.eventList,
  });

  final DateTime dateTime;
  final CalendarEventType eventType;
  final List<CalendarEvent>? eventList;

  @override
  List<Object?> get props => [dateTime, eventType, eventList];
}

class EventController extends Notifier<EventState> {
  late final EventUseCase useCase;
  final ScrollController scrollController = ScrollController();
  final Map<CalendarEventType, CalendarEventData> eventData = {};

  @override
  EventState build() {
    useCase = ref.watch(eventUseCaseProvider);
    ref.onDispose(scrollController.dispose);
    unawaited(Future<void>.microtask(refreshEventList));
    return EventState(
      dateTime: DateTime.now(),
      eventType: CalendarEventType.economics,
    );
  }

  Future<void> refreshEventList({
    CalendarEventType? newEventType,
    DateTime? newDateTime,
  }) async {
    final e = newEventType ?? state.eventType;
    final d = newDateTime ?? state.dateTime;
    state = EventState(dateTime: d, eventType: e);

    if (!eventData.containsKey(e)) {
      eventData[e] = {};
    }
    final List<CalendarEvent> tmpList = [];
    final data = eventData[e]!;
    final key = CalendarEvent.key(d);
    if (data.containsKey(key)) {
      tmpList.addAll(data[key]!);
    } else {
      final List<CalendarEvent> eventList = [];
      switch (e) {
        case CalendarEventType.economics:
          final list = await useCase.requestEconomicEventList(d);
          eventList.addAll(list.where((e) => e.country.code == 'US').toList());
          break;
        case CalendarEventType.earnings:
          eventList.addAll(await useCase.requestEarningEventList(d));
          break;
        case CalendarEventType.dividends:
          eventList.addAll(await useCase.requestDvidendEventList(d));
          break;
      }
      data[key] = eventList;
      eventData.update(e, (value) => data);
      tmpList.addAll(eventList);
    }
    state = EventState(dateTime: d, eventType: e, eventList: tmpList);
  }

  void jumpToTop() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }
}

final eventControllerProvider = NotifierProvider<EventController, EventState>(
  EventController.new,
);
