library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/data/service/service.dart';
import 'package:investing/repo/repo.dart';
part './news_impl.dart';

abstract class NewsRepo extends Repo {
  Future<dynamic> requestNewsList(int page);
  Future<List<dynamic>> searchNewsList(String query);

  Future<dynamic> searchStockNewsList({
    required String symbol,
    required String asset,
    required int page,
  });
}

final newsRepoProvider = Provider<NewsRepo>((ref) => NewsImpl());
