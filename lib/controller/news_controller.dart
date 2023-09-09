import 'package:get/get.dart';
import 'package:investing/controller/controller.dart';
import 'package:investing/model/news.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/use_case/news_use_case.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NewsController extends Controller<NewsUseCase> {
  NewsController(super.repo);

  static NewsController find() => Get.find<NewsController>();

  @override
  void onReady() {
    super.onReady();
    refreshNewsList();
  }

  final RefreshController refreshController = RefreshController();
  final List<News> _newsList = [];
  List<News> get newsList => _newsList;

  int _currentPage = 1;

  Future refreshNewsList() async {
    _currentPage = 1;
    _newsList.clear();
    final list = await useCase.requestlatestNewsList(_currentPage);
    newsList.addAll(list);
    refreshController.refreshCompleted();
  }

  Future requestNextPageNewsList() async {
    _currentPage++;
    final list = await useCase.requestlatestNewsList(_currentPage);
    _newsList.addAll(list);
    refreshController.loadComplete();
  }

// Search
  Future<List<News>> searchNews(String query) async {
    return await useCase.searchNewList(query);
  }

  Future<List<News>> searchStockNewsList({
    required Stock stock,
    required int page,
  }) {
    return useCase.searchStockNewsList(
      stock: stock,
      page: page,
    );
  }
}
