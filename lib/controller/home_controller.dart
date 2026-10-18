import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PageType { watchList, news, event, map, setting }

class HomeController extends Notifier<PageType> {
  @override
  PageType build() => PageType.watchList;

  set currentPage(PageType pageType) => state = pageType;
}

final homeControllerProvider = NotifierProvider<HomeController, PageType>(
  HomeController.new,
);
