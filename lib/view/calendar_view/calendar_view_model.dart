import 'package:dividends_manager/controller/calendar_controller.dart';
import 'package:dividends_manager/model/calendar_event.dart';
import 'package:dividends_manager/view/view.dart';
import 'package:dividends_manager/widget/calendar_widget.dart';
import 'package:flutter/material.dart';

class CalendarViewModel extends ViewModel<CalendarController> {
  final ScrollController scrollController = ScrollController();
  final CalendarEventData eventData = {};
  final Map<CalendarEventKey, GlobalKey> _keyData = {};
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

  GlobalKey eventKey(CalendarEventKey key) {
    if (_keyData[key] == null) {
      _keyData[key] = GlobalKey();
    }
    return _keyData[key]!;
  }

  void onTapCalendarDateTime(DateTime dateTime) {
    focusedDateTime = dateTime;

    GlobalKey? key;
    for (final entry in _keyData.entries) {
      if (entry.key.isSameDay(dateTime)) {
        key = entry.value;
        break;
      }
    }
    if (key == null) {
      return;
    }
    final context = key.currentContext;
    if (context == null) {
      return;
    }
    Scrollable.ensureVisible(
      context,
      duration: const Duration(
        milliseconds: 300,
      ),
    );
    updateView();
  }
}
