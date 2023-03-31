import 'package:flutter/material.dart';
import 'package:investing/controller/calendar_controller.dart';
import 'package:investing/model/calendar/calendar_event.dart';
import 'package:investing/view/view.dart';

class CalendarEventViewModel extends ViewModel<CalendarController> {
  CalendarEventViewModel(this.type);
  final CalendarEventType type;
  final ScrollController scrollController = ScrollController();
  final CalendarEventData eventData = {};
  final Map<String, GlobalKey> _keyData = {};
  DateTime focusedDateTime = DateTime.now();

  @override
  Future init() {
    requestEventList();
    return super.init();
  }

  List<CalendarEvent>? loadEventList() {
    final key = CalendarEvent.key(focusedDateTime);
    return eventData[key];
  }

  Future requestEventList() async {
    await overlayLoading(() async {
      final dateTime = focusedDateTime;
      final key = CalendarEvent.key(dateTime);
      if (eventData.containsKey(key)) {
        return;
      }
      final eventList = await controller.requestEventList(
        dateTime: dateTime,
        eventType: type,
      );

      if (eventList.isEmpty) {
        eventData[key] = [];
        return;
      }
      for (final event in eventList) {
        if (!eventData.containsKey(key)) {
          eventData[key] = [];
        }
        eventData[key]!.add(event);
      }
    });
  }

  void onChangedFoucsedDateTime(DateTime dateTime) async {
    focusedDateTime = dateTime;
    await requestEventList();
  }

  GlobalKey eventKey(String key) {
    if (_keyData[key] == null) {
      _keyData[key] = GlobalKey();
    }
    return _keyData[key]!;
  }
}
