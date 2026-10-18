import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/controller/setting_controller.dart';

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
          ],
        ),
      ),
    );
  }
}
