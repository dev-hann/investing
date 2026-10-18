import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/model/news.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/repo/news/news_repo.dart';
import 'package:investing/use_case/use_case.dart';

class NewsUseCase extends UseCase<NewsRepo> {
  NewsUseCase(super.repo);

  Future<List<News>> requestlatestNewsList(int page) {
    return repo.requestNewsList(page);
  }

  Future<List<News>> searchNewList(String query) {
    return repo.searchNewsList(query);
  }

  Future<List<News>> searchStockNewsList({
    required Stock stock,
    required int page,
  }) {
    return repo.searchStockNewsList(
      symbol: stock.symbol,
      asset: stock.asset,
      page: page,
    );
  }
}

final newsUseCaseProvider = Provider(
  (ref) => NewsUseCase(ref.watch(newsRepoProvider)),
);
