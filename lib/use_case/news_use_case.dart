import 'package:investing/model/news.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/repo/news/news_repo.dart';
import 'package:investing/use_case/use_case.dart';

class NewsUseCase extends UseCase<NewsRepo> {
  NewsUseCase(super.repo);

  Future<List<News>> requestlatestNewsList(int page) async {
    final res = await repo.requestNewsList(page);
    final list = List.from(res);
    return list.map((e) => News.latest(e)).toList();
  }

  Future<List<News>> searchNewList(String query) async {
    final list = await repo.searchNewsList(query);
    return list.map((e) => News.search(e)).toList();
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
    return List.from(res).map((e) => News.latest(e)).toList();
  }
}
