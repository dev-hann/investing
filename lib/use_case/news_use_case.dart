import 'package:investing/model/news.dart';
import 'package:investing/repo/news/news_repo.dart';
import 'package:investing/use_case/use_case.dart';

class NewsUseCase extends UseCase<NewsRepo> {
  NewsUseCase(super.repo);

  Future<List<News>> requestNewsList() async {
    // final res = await repo.requestNewsList();
    return [];
  }
}
