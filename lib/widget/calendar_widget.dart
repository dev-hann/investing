import 'package:dividends_manager/model/calendar_event.dart';
import 'package:dividends_manager/widget/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({
    super.key,
    required this.eventList,
    required this.onChangedPage,
  });
  final List<CalendarEvent> eventList;
  final Function(DateTime dateTime) onChangedPage;

  Widget calendarWidget() {
    return Card(
      child: TableCalendar(
        calendarFormat: CalendarFormat.twoWeeks,
        headerStyle: const HeaderStyle(
          titleCentered: true,
          formatButtonVisible: false,
        ),
        firstDay: DateTime(1970),
        focusedDay: DateTime.now(),
        lastDay: DateTime(2024),
        onPageChanged: onChangedPage,
      ),
    );
  }

  Widget eventListView() {
    final Map<String, List<CalendarEvent>> sortedMap = {};
    for (final event in eventList) {
      final key = event.key;
      if (!sortedMap.containsKey(key)) {
        sortedMap[key] = [];
      }
      sortedMap[key]!.add(event);
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: sortedMap.keys.map((key) {
          final list = sortedMap[key]!;
          return TitleWidget(
            title: Text(key),
            child: Column(
              children: list.map((e) {
                return ListTile(
                  title: Text(e.dateTime.toString()),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
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
