import 'package:dividends_manager/controller/controller.dart';
import 'package:dividends_manager/data/service/service.dart';
import 'package:dividends_manager/model/news.dart';

class NewsController extends Controller {
  final NewsService newsService = NewsService();
  Future<List<News>> requestNewsList(int page) async {
    final res = await newsService.requestLatestNewsList(page);
    final list = List<Map<String, dynamic>>.from(
      res["data"]["rows"],
    );
    return list.map((e) => News.dto(e)).toList();
  }

  Future<List<News>> searchNews(String query) async {
    final list = await newsService.searchNews(query);
    return list.map((e) => News.dto(e)).toList();
  }
}
