import 'package:dividends_manager/model/calendar_event.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

typedef CalendarEventBuilder = Widget Function(
    CalendarEventKey eventKey, List<CalendarEvent> eventList);
typedef CalendarEventData = Map<CalendarEventKey, List<CalendarEvent>>;

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({
    super.key,
    required this.scrollController,
    required this.eventData,
    required this.onChangedPage,
    required this.onChangedDateTime,
    required this.eventBuilder,
    required this.focusedDateTime,
  });
  final ScrollController scrollController;
  final CalendarEventData eventData;
  final Function(DateTime dateTime) onChangedPage;
  final Function(DateTime dateTime) onChangedDateTime;
  final CalendarEventBuilder eventBuilder;
  final DateTime focusedDateTime;

  Widget calendarWidget() {
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
        onPageChanged: onChangedPage,
        onDaySelected: (selectedDay, focusedDay) {
          onChangedDateTime(selectedDay);
        },
      ),
    );
  }

  Widget eventListView() {
    //TODO:  Cannot Scroll? FIX HERE
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      physics: const BouncingScrollPhysics(),
      children: eventData.keys.map((key) {
        return eventBuilder(key, eventData[key] ?? []);
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: calendarWidget(),
        ),
        Expanded(
          child: eventListView(),
        ),
      ],
    );
  }
}
