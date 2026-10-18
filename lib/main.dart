import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forui/forui.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:investing/const/theme.dart';
import 'package:investing/controller/setting_controller.dart';
import 'package:investing/data/config.dart';
import 'package:investing/view/home_view/home_view.dart';
import 'package:investing/widget/snackbar.dart';

void main() async {
  await Hive.initFlutter();
  await IVConfig.load();
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
      localizationsDelegates: FLocalizations.localizationsDelegates,
      supportedLocales: FLocalizations.supportedLocales,
      theme: IVTheme.materialLight(),
      darkTheme: IVTheme.materialDark(),
      builder: (context, child) => FTheme(
        data: Theme.of(context).brightness == Brightness.dark
            ? IVTheme.dark()
            : IVTheme.light(),
        child: FToaster(child: FTooltipGroup(child: child!)),
      ),
      home: const HomeView(),
    );
  }
}
