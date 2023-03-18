import 'package:dividends_manager/controller/home_controller.dart';
import 'package:dividends_manager/view/calendar_view/calendar_view.dart';
import 'package:dividends_manager/view/home_view/home_view_model.dart';
import 'package:dividends_manager/view/news_view/news_view.dart';
import 'package:dividends_manager/view/view.dart';
import 'package:dividends_manager/view/watch_list_view/watch_list_view.dart';
import 'package:flutter/material.dart';

class HomeView extends View<HomeViewModel, HomeController> {
  HomeView({super.key}) : super(viewModel: HomeViewModel());

  Widget bottom() {
    return BottomNavigationBar(
      onTap: viewModel.onChangedPage,
      currentIndex: viewModel.currentPage,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.star_border),
          label: "WatchList",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.newspaper_outlined),
          label: "News",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: "Calendar",
        ),
      ],
    );
  }

  @override
  Widget body() {
    return Scaffold(
      bottomNavigationBar: bottom(),
      body: PageView(
        controller: viewModel.pageController,
        children: [
          WatchListView(),
          NewsView(),
          CalendarView(),
        ],
      ),
    );
  }
}
