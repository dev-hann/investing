import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investing/controller/controller.dart';
import 'package:investing/model/calendar/calendar_event.dart';
import 'package:investing/use_case/event_use_case.dart';

typedef CalendarEventData = Map<String, List<CalendarEvent>>;

class EventController extends Controller<EventUseCase> {
  EventController(super.useCase);
  static EventController find() => Get.find<EventController>();
  final Map<CalendarEventType, CalendarEventData> eventData = {};
  DateTime dateTime = DateTime.now();
  CalendarEventType eventType = CalendarEventType.economics;
  List<CalendarEvent>? eventList;
  final ScrollController scrollController = ScrollController();

  @override
  void onReady() {
    refreshEventList();
    super.onReady();
  }

  Future refreshEventList({
    CalendarEventType? newEventType,
    DateTime? newDateTime,
  }) async {
    final e = newEventType ?? eventType;
    final d = newDateTime ?? dateTime;
    dateTime = d;
    eventType = e;

    if (!eventData.containsKey(e)) {
      eventData[e] = {};
    }
    eventList = null;
    update();
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
          eventList.addAll(list.where((e) => e.country.code == "US").toList());
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
    eventList = tmpList;
    update();
  }

  void jumpToTop() {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }
}
