import 'package:get/get.dart';
import 'package:investing/const/color.dart';
import 'package:investing/view/event_view/event_view.dart';
import 'package:investing/view/market_view/market_view.dart';
import 'package:investing/view/news_view/news_view.dart';
import 'package:investing/view/setting_view/setting_view.dart';
import 'package:investing/view/stock_view/stock_view.dart';
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
        controller: pageController,
        children: const [
          StockView(),
          NewsView(),
          EventView(),
          // ScreenerView(),
          MarketView(),
          SettingView()
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
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: "Event",
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.filter_list),
            //   label: "Screener",
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: "Map",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Setting",
            ),
          ],
        );
      }),
    );
  }
}
