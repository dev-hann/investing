library news_repo;

import 'package:investing/data/service/service.dart';
import 'package:investing/repo/repo.dart';
part './news_impl.dart';

abstract class NewsRepo extends Repo {
  Future<dynamic> requestNewsList(int page);
  Future<dynamic> searchNewsList(String query);

  Future<dynamic> searchStockNewsList({
    required String symbol,
    required String asset,
    required int page,
  });
}
