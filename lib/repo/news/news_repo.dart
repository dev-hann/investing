library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/data/service/service.dart';
import 'package:investing/model/news.dart';
import 'package:investing/repo/repo.dart';
part './news_impl.dart';

abstract class NewsRepo extends Repo {
  Future<List<News>> requestNewsList(int page);
  Future<List<News>> searchNewsList(String query);

  Future<List<News>> searchStockNewsList({
    required String symbol,
    required String asset,
    required int page,
  });
}

final newsRepoProvider = Provider<NewsRepo>((ref) => NewsImpl());
