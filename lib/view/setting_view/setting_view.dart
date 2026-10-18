import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/controller/setting_controller.dart';
import 'package:investing/util/navigator.dart';
import 'package:investing/view/setting_view/screener_view/screener_view.dart';

class SettingView extends ConsumerWidget {
  const SettingView({super.key});

  AppBar appBar() {
    return AppBar(title: const Text('Setting'));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // TODO: (Future Work) Fix light theme mode
            SwitchListTile(
              title: const Text('Dark Mode'),
              onChanged: (bool value) {
                ref.read(settingControllerProvider.notifier).themeMode = value
                    ? ThemeMode.dark
                    : ThemeMode.light;
              },
              value: isDarkMode,
            ),
            ListTile(
              onTap: () {
                unawaited(pushView(context, const ScreenerView()));
              },
              title: const Text('Screener'),
            ),
          ],
        ),
      ),
    );
  }
}
