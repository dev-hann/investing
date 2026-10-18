import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/model/news.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/use_case/news_use_case.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class NewsController extends Notifier<List<News>> {
  late final NewsUseCase useCase;
  final RefreshController refreshController = RefreshController();

  int _currentPage = 1;

  @override
  List<News> build() {
    useCase = ref.watch(newsUseCaseProvider);
    ref.onDispose(refreshController.dispose);
    unawaited(Future<void>.microtask(refreshNewsList));
    return [];
  }

  Future<void> refreshNewsList() async {
    _currentPage = 1;
    state = [];
    final list = await useCase.requestlatestNewsList(_currentPage);
    state = list;
    refreshController.refreshCompleted();
  }

  Future<void> requestNextPageNewsList() async {
    _currentPage++;
    final list = await useCase.requestlatestNewsList(_currentPage);
    state = [...state, ...list];
    refreshController.loadComplete();
  }

  // Search
  Future<List<News>> searchNews(String query) async {
    return await useCase.searchNewList(query);
  }

  Future<List<News>> searchStockNewsList({
    required Stock stock,
    required int page,
  }) {
    return useCase.searchStockNewsList(stock: stock, page: page);
  }
}

final newsControllerProvider = NotifierProvider<NewsController, List<News>>(
  NewsController.new,
);
