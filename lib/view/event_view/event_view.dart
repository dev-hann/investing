import 'package:get/get.dart';
import 'package:investing/controller/event_controller.dart';
import 'package:investing/model/calendar/calendar_event.dart';
import 'package:investing/util/date_time_format.dart';
import 'package:investing/view/event_view/calendar_event_card/dividend_event_card.dart';
import 'package:investing/view/event_view/calendar_event_card/earming_event_card.dart';
import 'package:investing/view/event_view/calendar_event_card/economic_event_card.dart';
import 'package:investing/view/event_view/event_search_view/evnet_search_view.dart';
import 'package:investing/widget/loading_widget.dart';
import 'package:investing/widget/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class EventView extends StatefulWidget {
  const EventView({super.key});

  @override
  State<EventView> createState() => _EventViewState();
}

class _EventViewState extends State<EventView> {
  AppBar appBar() {
    const typeList = CalendarEventType.values;
    return AppBar(
      title: GestureDetector(
        // onTap: jumpToTop,
        child: const Text("Event"),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Get.to(const EventSearchView());
          },
          icon: const Icon(Icons.search),
        )
      ],
      bottom: TabBar(
        onTap: (index) async {
          // jumpToTop();
          // controller.refreshEventList(newEventType: typeList[index]);
          // requestEventList(newEventType: typeList[index]);
        },
        tabs: typeList
            .map(
              (e) => Tab(text: e.name.capitalize),
            )
            .toList(),
      ),
    );
  }

  Widget calendarWidget({
    required DateTime selectedDateTime,
    required Function(DateTime dateTime) onTapDateTime,
  }) {
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
        focusedDay: selectedDateTime,
        lastDay: DateTime(2024),
        calendarStyle: const CalendarStyle(
          isTodayHighlighted: false,
        ),
        selectedDayPredicate: (dateTime) {
          return isSameDay(dateTime, selectedDateTime);
        },
        onPageChanged: (dateTime) {},
        onDaySelected: (selectedDay, focusedDay) {
          onTapDateTime(selectedDay);
        },
      ),
    );
  }

  Widget eventListView({
    required CalendarEventType eventType,
    required List<CalendarEvent>? eventList,
    required DateTime selectedDatetime,
  }) {
    if (eventList == null) {
      return const IVLoadingWidget(
        background: Colors.transparent,
      );
    }
    if (eventList.isEmpty) {
      return const Text("No Result");
    }

    return TitleWidget(
      title: Row(
        children: [
          Expanded(
            child: Text(
                "${IVDateTimeFormat(selectedDatetime).dateTimeFormat()} (${eventList.length})"),
          ),
          // TODO: make filter
          GestureDetector(
            onTap: () {},
            child: const Icon(Icons.filter_list),
          ),
        ],
      ),
      child: Column(
        children: eventList.map((element) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Builder(builder: (context) {
              // return Text(element.runtimeType.toString());
              switch (eventType) {
                case CalendarEventType.economics:
                  return EconomicEventCard(
                    event: element as EconomicEvent,
                  );
                case CalendarEventType.earnings:
                  return EarningEventCard(
                    event: element as EarningEvent,
                  );
                case CalendarEventType.dividends:
                  return DividendEventCard(
                    event: element as DividendEvent,
                  );
              }
            }),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EventController>(builder: (controller) {
      final typeList = CalendarEventType.values.toList();
      final type = controller.eventType;
      final eventList = controller.eventList;
      final selectedDateTime = controller.dateTime;
      return DefaultTabController(
        initialIndex: typeList.indexWhere((element) => element == type),
        length: typeList.length,
        child: Scaffold(
          appBar: appBar(),
          body: ListView(
            controller: controller.scrollController,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            children: [
              calendarWidget(
                onTapDateTime: (dateTime) {
                  controller.refreshEventList(newDateTime: dateTime);
                },
                selectedDateTime: selectedDateTime,
              ),
              const SizedBox(height: 16.0),
              eventListView(
                eventType: type,
                eventList: eventList,
                selectedDatetime: selectedDateTime,
              ),
            ],
          ),
        ),
      );
    });
  }
}
