import 'package:dividends_manager/controller/calendar_controller.dart';
import 'package:dividends_manager/view/calendar_view/calendar_view_model.dart';
import 'package:dividends_manager/view/view.dart';
import 'package:dividends_manager/widget/calendar_widget.dart';
import 'package:dividends_manager/widget/title_widget.dart';
import 'package:flutter/material.dart';

class CalendarView extends View<CalendarViewModel, CalendarController> {
  CalendarView({super.key}) : super(viewModel: CalendarViewModel());

  AppBar appBar() {
    return AppBar(
      title: const Text("Calendar"),
      bottom: tabView(),
    );
  }

  TabBar tabView() {
    return const TabBar(
      isScrollable: true,
      tabs: [
        Tab(
          text: "Economic",
        ),
        Tab(
          text: "Earnings",
        ),
        Tab(
          text: "IPO",
        ),
        Tab(
          text: "Dividend",
        ),
        Tab(
          text: "SPO",
        ),
        Tab(
          text: "Holiday",
        ),
      ],
    );
  }

  Widget economicView() {
    return CalendarWidget(
      scrollController: viewModel.scrollController,
      eventData: viewModel.eventData,
      focusedDateTime: viewModel.focusedDateTime,
      onChangedPage: (dateTme) {},
      onChangedDateTime: (dateTime) {
        viewModel.onTapCalendarDateTime(dateTime);
      },
      eventBuilder: (key, eventList) {
        return TitleWidget(
          title: Text(key.dateTime.toString()),
          child: Column(
            children: eventList.map((event) {
              return Card(
                child: ListTile(
                  title: Text(event.toString()),
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
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: appBar(),
        body: TabBarView(
          children: [
            economicView(),
            economicView(),
            economicView(),
            economicView(),
            economicView(),
            economicView(),
          ],
        ),
      ),
    );
  }
}
