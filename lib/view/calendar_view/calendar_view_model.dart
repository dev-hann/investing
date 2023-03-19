import 'package:dividends_manager/controller/calendar_controller.dart';
import 'package:dividends_manager/model/calendar_event.dart';
import 'package:dividends_manager/view/view.dart';
import 'package:dividends_manager/widget/calendar_widget.dart';
import 'package:flutter/material.dart';

class CalendarViewModel extends ViewModel<CalendarController> {
  final ScrollController scrollController = ScrollController();
  final CalendarEventData eventData = {};
  final List<GlobalKey> _keyList = [];
  DateTime focusedDateTime = DateTime.now();

  @override
  Future init() {
    final eventList = List.generate(
      20,
      (index) {
        return EconomicEvent(
          dateTime: DateTime.now().add(Duration(days: index)),
        );
      },
    );
    eventList.addAll(
      List.generate(
        20,
        (index) {
          return EconomicEvent(
            dateTime: DateTime.now().add(Duration(days: index)),
          );
        },
      ),
    );
    eventData.clear();
    for (final event in eventList) {
      final key = event.eventKey;
      if (!eventData.containsKey(key)) {
        eventData[key] = [];
      }
      eventData[key]!.add(event);
    }
    return super.init();
  }

  void onTapCalendarDateTime(DateTime dateTime) {
    focusedDateTime = dateTime;
    updateView();
  }
}
