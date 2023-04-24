import 'package:get/get.dart';
import 'package:investing/controller/controller.dart';
import 'package:investing/model/news.dart';
import 'package:investing/use_case/news_use_case.dart';

class NewsController extends Controller<NewsUseCase> {
  NewsController(super.repo);

  final RxList<News> newsList = RxList();

  Future refreshNewsList() async {
    final list = useCase.requestNewsList();
  }

  Future<List<News>> requestNewsList(int page) async {
    return [];
    // final res = await newsService.requestLatestNewsList(page);
    // final list = List<Map<String, dynamic>>.from(
    //   res["data"]["rows"],
    // );
    // return list.map((e) => News.dto(e)).toList();
  }

  Future<List<News>> searchNews(String query) async {
    return [];
    // final list = await newsService.searchNews(query);
    // return list.map((e) => News.dto(e)).toList();
  }
}
