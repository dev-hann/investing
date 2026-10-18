import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:investing/controller/home_controller.dart';
import 'package:investing/controller/news_controller.dart';
import 'package:investing/controller/setting_controller.dart';
import 'package:investing/repo/news/news_repo.dart';

class _FakeNewsRepo extends NewsRepo {
  @override
  Future<dynamic> requestNewsList(int page) async {
    return [
      {
        'id': page,
        'title': 'title $page',
        'ago': '1 hour ago',
        'publisher': 'p',
        'url': '/article/$page',
        'image': '',
        'imagedomain': '',
      },
    ];
  }

  @override
  Future<List<dynamic>> searchNewsList(String query) {
    throw UnimplementedError();
  }

  @override
  Future<dynamic> searchStockNewsList({
    required String symbol,
    required String asset,
    required int page,
  }) {
    throw UnimplementedError();
  }
}

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

  test('NewsController loads the first page via a fake repo', () async {
    final container = ProviderContainer(
      overrides: [newsRepoProvider.overrideWithValue(_FakeNewsRepo())],
    );
    addTearDown(container.dispose);

    // Providers are lazy: read once to initialize the notifier, then let
    // the microtask-scheduled initial fetch complete.
    container.read(newsControllerProvider);
    await Future<void>.delayed(Duration.zero);

    final list = container.read(newsControllerProvider);
    expect(list, hasLength(1));
    expect(list.single.title, 'title 1');
  });
}
