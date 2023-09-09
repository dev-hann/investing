import 'package:get/get.dart';
import 'package:investing/controller/home_controller.dart';
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
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        final currentIndex = controller.currentPage.index;
        return Scaffold(
          body: Builder(builder: (context) {
            return const [
              StockView(),
              NewsView(),
              EventView(),
              MarketView(),
              SettingView()
            ][currentIndex];
          }),
          bottomNavigationBar: NavigationBar(
            selectedIndex: currentIndex,
            onDestinationSelected: (index) {
              controller.moveToPage(PageType.values[index]);
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.star_border),
                label: "WatchList",
              ),
              NavigationDestination(
                icon: Icon(Icons.newspaper_outlined),
                label: "News",
              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_month),
                label: "Event",
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.filter_list),
              //   label: "Screener",
              // ),
              NavigationDestination(
                icon: Icon(Icons.map),
                label: "Map",
              ),
              NavigationDestination(
                icon: Icon(Icons.person),
                label: "Setting",
              ),
            ],
          ),
        );
      },
    );
  }
}
