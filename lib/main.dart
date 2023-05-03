import 'package:get/get.dart';
import 'package:investing/const/color.dart';
import 'package:investing/controller/event_controller.dart';
import 'package:investing/controller/controller.dart';
import 'package:investing/controller/market_controller.dart';
import 'package:investing/controller/news_controller.dart';
import 'package:investing/controller/setting_controller.dart';
import 'package:investing/controller/stock_controller.dart';
import 'package:investing/repo/event/event_repo.dart';
import 'package:investing/repo/market/market_repo.dart';
import 'package:investing/repo/news/news_repo.dart';
import 'package:investing/repo/setting/setting_impl.dart';
import 'package:investing/repo/stock/stock_repo.dart';
import 'package:investing/use_case/event_use_case.dart';
import 'package:investing/use_case/market_use_case.dart';
import 'package:investing/use_case/news_use_case.dart';
import 'package:investing/use_case/setting_use_case.dart';
import 'package:investing/use_case/stock_use_case.dart';
import 'package:investing/view/home_view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: BindingsBuilder(
        () {
          Controller.put<SettingController>(
            SettingController(
              SettingUseCase(SettingImpl()),
            ),
          );
          Controller.put<StockController>(
            StockController(
              StockUseCase(StockImpl()),
            ),
          );
          Controller.put<NewsController>(
            NewsController(
              NewsUseCase(NewsImpl()),
            ),
          );
          Controller.put<EventController>(
            EventController(
              EventUseCase(EventImpl()),
            ),
          );
          Controller.put<MarketController>(
            MarketController(
              MarketUseCase(MarketImpl()),
            ),
          );
        },
      ),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: IVColor.orange,
        tabBarTheme: const TabBarTheme(
          labelColor: IVColor.white,
          unselectedLabelColor: IVColor.darkWhite,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
        cardTheme: CardTheme(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
      ),
      theme: ThemeData(
        primaryColor: IVColor.orange,
        tabBarTheme: const TabBarTheme(
          labelColor: IVColor.white,
          unselectedLabelColor: IVColor.darkWhite,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
        cardTheme: CardTheme(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
      ),
      home: const HomeView(),
    );
  }
}
