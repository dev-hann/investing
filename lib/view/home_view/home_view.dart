import 'package:get/get.dart';
import 'package:investing/const/color.dart';
<<<<<<< HEAD
import 'package:investing/view/news_view/news_view.dart';
import 'package:investing/view/stock_view/stock_view.dart';
=======
import 'package:investing/controller/home_controller.dart';
import 'package:investing/view/home_view/home_view_model.dart';
import 'package:investing/view/view.dart';
import 'package:investing/view/watch_list_view/watch_list_view.dart';
>>>>>>> main
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final PageController pageController = PageController(keepPage: true);

  final RxInt currentPage = RxInt(0);

  @override
  void initState() {
    super.initState();
    pageController.addListener(() {
      currentPage(pageController.page?.round());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
<<<<<<< HEAD
        controller: pageController,
        children: const [
          StockView(),
          NewsView(),
=======
        controller: viewModel.pageController,
        children: const [
          WatchListView(),
          // NewsView(),
>>>>>>> main
          // CalendarView(),
          // FinVizView(),
        ],
      ),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          onTap: pageController.jumpToPage,
          currentIndex: currentPage.value,
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
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.calendar_month),
            //   label: "Calendar",
            // ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.map),
            //   label: "FinViz",
            // ),
          ],
        );
      }),
    );
  }
}
