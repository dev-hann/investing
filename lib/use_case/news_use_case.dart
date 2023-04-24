import 'package:investing/model/news.dart';
import 'package:investing/repo/news/news_repo.dart';
import 'package:investing/use_case/use_case.dart';

class NewsUseCase extends UseCase<NewsRepo> {
  NewsUseCase(super.repo);

  Future<List<News>> requestlatestNewsList(int page) async {
    final res = await repo.requestNewsList(page);
    final list = List.from(res);
    return list.map((e) => News.fromMap(e)).toList();
  }
}
