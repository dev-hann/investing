import 'package:investing/const/color.dart';
import 'package:investing/controller/home_controller.dart';
import 'package:investing/view/home_view/home_view_model.dart';
import 'package:investing/view/view.dart';
import 'package:investing/view/watch_list_view/watch_list_view.dart';
import 'package:flutter/material.dart';

class HomeView extends View<HomeViewModel, HomeController> {
  HomeView({super.key}) : super(viewModel: HomeViewModel());

  Widget bottom() {
    return BottomNavigationBar(
      onTap: viewModel.onChangedPage,
      currentIndex: viewModel.currentPage,
      selectedItemColor: IVColor.orange,
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
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: "FinViz",
        ),
      ],
    );
  }

  @override
  Widget body() {
    return Scaffold(
      // bottomNavigationBar: bottom(),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: viewModel.pageController,
        children: const [
          WatchListView(),
          // NewsView(),
          // CalendarView(),
          // FinVizView(),
        ],
      ),
    );
  }
}
