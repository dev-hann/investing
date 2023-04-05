import 'package:investing/controller/calendar_controller.dart';
import 'package:investing/model/calendar/calendar_event.dart';
import 'package:flutter/material.dart';
import 'package:investing/view/calendar_view/calendar_event_view/calendar_event_view_model.dart';
import 'package:investing/view/view.dart';
import 'package:table_calendar/table_calendar.dart';

typedef CalendarEventBuilder = Widget Function(
    DateTime dateTime, List<CalendarEvent> eventList);

class CalendarEventView
    extends View<CalendarEventViewModel, CalendarController> {
  CalendarEventView({
    super.key,
    required CalendarEventType type,
    required this.eventBuilder,
  }) : super(viewModel: CalendarEventViewModel(type));
  final CalendarEventBuilder eventBuilder;

  Widget calendarWidget() {
    final focusedDateTime = viewModel.focusedDateTime;
    return Card(
      child: TableCalendar(
        calendarFormat: CalendarFormat.twoWeeks,
        headerStyle: const HeaderStyle(
          headerPadding: EdgeInsets.zero,
          titleCentered: true,
          formatButtonVisible: false,
        ),
        rowHeight: 40.0,
        firstDay: DateTime(1970),
        focusedDay: focusedDateTime,
        lastDay: DateTime(2024),
        calendarStyle: const CalendarStyle(
          isTodayHighlighted: false,
        ),
        selectedDayPredicate: (dateTime) {
          return isSameDay(dateTime, focusedDateTime);
        },
        onPageChanged: (dateTime) {},
        onDaySelected: (selectedDay, focusedDay) {
          viewModel.onChangedFoucsedDateTime(selectedDay);
        },
      ),
    );
  }

  Widget eventListView() {
    final eventList = viewModel.loadEventList();
    if (eventList == null) {
      return const SizedBox();
    }
    if (eventList.isEmpty) {
      return const Text("No Result");
    }
    return eventBuilder(viewModel.focusedDateTime, eventList);
  }

  @override
  Widget body() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      children: [
        calendarWidget(),
        const SizedBox(height: 16.0),
        eventListView(),
      ],
    );
  }
}
