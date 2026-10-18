import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/model/news.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/repo/news/news_repo.dart';
import 'package:investing/use_case/use_case.dart';

class NewsUseCase extends UseCase<NewsRepo> {
  NewsUseCase(super.repo);

  Future<List<News>> requestlatestNewsList(int page) async {
    final res = await repo.requestNewsList(page);
    final list = List<dynamic>.from(res as List<dynamic>);
    return list.map((e) => News.latest(e as Map<String, dynamic>)).toList();
  }

  Future<List<News>> searchNewList(String query) async {
    final list = await repo.searchNewsList(query);
    return list.map((e) => News.search(e as Map<String, dynamic>)).toList();
  }

  Future<List<News>> searchStockNewsList({
    required Stock stock,
    required int page,
  }) async {
    final res = await repo.searchStockNewsList(
      symbol: stock.symbol,
      asset: stock.asset,
      page: page,
    );
    return List<dynamic>.from(res as List<dynamic>)
        .map((e) => News.latest(e as Map<String, dynamic>))
        .toList();
  }
}

final newsUseCaseProvider = Provider(
  (ref) => NewsUseCase(ref.watch(newsRepoProvider)),
);
