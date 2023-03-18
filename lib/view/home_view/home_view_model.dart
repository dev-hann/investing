import 'package:dividends_manager/controller/calendar_controller.dart';
import 'package:dividends_manager/controller/controller.dart';
import 'package:dividends_manager/controller/home_controller.dart';
import 'package:dividends_manager/controller/news_controller.dart';
import 'package:dividends_manager/controller/watch_list_controller.dart';
import 'package:dividends_manager/view/view.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ViewModel<HomeController> {
  @override
  Future init() {
    Controller.put<WatchListController>(WatchListController());
    Controller.put<NewsController>(NewsController());
    Controller.put<CalendarController>(CalendarController());
    return super.init();
  }

  PageController get pageController => controller.pageController;
  int get currentPage => controller.currentPage;
  void onChangedPage(int index) {
    pageController.jumpToPage(index);
  }
}
