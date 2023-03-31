import 'package:investing/controller/calendar_controller.dart';
import 'package:investing/model/calendar/calendar_event.dart';
import 'package:investing/util/date_time_format.dart';
import 'package:investing/view/calendar_view/calendar_event_card/economic_event_card.dart';
import 'package:investing/view/calendar_view/detail_view/calendar_detail_view.dart';
import 'package:investing/view/calendar_view/calendar_view_model.dart';
import 'package:investing/view/view.dart';
import 'package:investing/view/calendar_view/calendar_event_view/calendar_event_view.dart';
import 'package:investing/widget/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalendarView extends View<CalendarViewModel, CalendarController> {
  CalendarView({super.key}) : super(viewModel: CalendarViewModel());

  AppBar appBar() {
    return AppBar(
      title: const Text("Calendar"),
      bottom: tabView(),
    );
  }

  TabBar tabView() {
    return TabBar(
      isScrollable: true,
      onTap: (index) {},
      tabs: viewModel.eventTypeList.map((e) {
        return Tab(text: e.name.capitalize);
      }).toList(),
    );
  }

  Widget calendarWidget(CalendarEventType eventType) {
    return CalendarEventView(
      type: eventType,
      eventBuilder: (dateTime, eventList) {
        return TitleWidget(
          title: Text(IVDateTimeFormat(dateTime).dateTimeFormat()),
          child: Column(
            children: eventList.map((event) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Builder(
                  builder: (context) {
                    switch (eventType) {
                      case CalendarEventType.economics:
                        return EconomicEventCard(
                          event: event as EconomicEvent,
                        );
                      case CalendarEventType.earnings:
                        break;
                      case CalendarEventType.dividends:
                        break;
                    }
                    return const SizedBox();
                  },
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget body() {
    final typeList = viewModel.eventTypeList;
    return DefaultTabController(
      length: typeList.length,
      child: Scaffold(
        appBar: appBar(),
        body: TabBarView(
          children: typeList.map(calendarWidget).toList(),
        ),
      ),
    );
  }
}
