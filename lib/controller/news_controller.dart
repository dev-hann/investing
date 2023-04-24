import 'package:get/get.dart';
import 'package:investing/controller/controller.dart';
import 'package:investing/model/news.dart';
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

  final RxList<News> newsList = RxList();
  int _currentPage = 1;

  Future refreshNewsList() async {
    _currentPage = 0;
    await requestNextPageNewsList(clearList: true);
    refreshController.refreshCompleted();
  }

  Future requestNextPageNewsList({
    bool clearList = false,
  }) async {
    _currentPage++;
    final list = await useCase.requestlatestNewsList(_currentPage);
    if (clearList) {
      newsList.clear();
    }
    newsList.addAll(list);
    refreshController.loadComplete();
  }

// Search
  final RxList<News> searchedList = RxList();
  Future searchNews(String query) async {
    final list = await useCase.searchNewList(query);
    searchedList(list);
  }
}
