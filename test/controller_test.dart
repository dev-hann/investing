import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:investing/controller/home_controller.dart';
import 'package:investing/controller/setting_controller.dart';

void main() {
  test('HomeController starts on watchList and moves pages', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(homeControllerProvider), PageType.watchList);

    container.read(homeControllerProvider.notifier).currentPage = PageType.map;
    expect(container.read(homeControllerProvider), PageType.map);
  });

  test('SettingController changes theme mode', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(settingControllerProvider), ThemeMode.system);

    container.read(settingControllerProvider.notifier).themeMode =
        ThemeMode.dark;
    expect(container.read(settingControllerProvider), ThemeMode.dark);
  });
}
