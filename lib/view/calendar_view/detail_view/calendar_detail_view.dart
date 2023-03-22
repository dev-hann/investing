import 'package:investing/controller/calendar_controller.dart';
import 'package:investing/model/calendar_event.dart';
import 'package:investing/view/calendar_view/detail_view/calendar_detail_view_mode.dart';
import 'package:investing/view/view.dart';
import 'package:flutter/material.dart';

class CalendarDetailView
    extends View<CalendarDetailViewModel, CalendarController> {
  CalendarDetailView({
    super.key,
    required this.event,
  }) : super(viewModel: CalendarDetailViewModel());

  final CalendarEvent event;

  AppBar appBar() {
    return AppBar(
      title: const Text("Detail View"),
    );
  }

  @override
  Widget body() {
    return Scaffold(
      appBar: appBar(),
      body: const Text("Detail View"),
    );
  }
}
