import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:investing/const/color.dart';
import 'package:investing/controller/setting_controller.dart';
import 'package:investing/view/home_view/home_view.dart';
import 'package:investing/widget/snackbar.dart';

void main() async {
  await Hive.initFlutter();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      debugShowCheckedModeBanner: false,
      themeMode: ref.watch(settingControllerProvider),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: IVColor.orange,
        tabBarTheme: const TabBarThemeData(
          labelColor: IVColor.white,
          unselectedLabelColor: IVColor.darkWhite,
        ),
        appBarTheme: const AppBarTheme(centerTitle: true),
        cardTheme: CardThemeData(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
      ),
      theme: ThemeData.light().copyWith(
        primaryColor: IVColor.orange,
        tabBarTheme: const TabBarThemeData(
          labelColor: IVColor.white,
          unselectedLabelColor: IVColor.darkWhite,
        ),
        appBarTheme: const AppBarTheme(centerTitle: true),
        cardTheme: CardThemeData(
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
