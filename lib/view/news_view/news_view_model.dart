import 'package:dividends_manager/controller/news_controller.dart';
import 'package:dividends_manager/model/news.dart';
import 'package:dividends_manager/view/view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NewsViewModel extends ViewModel<NewsController> {
  final RefreshController refreshController = RefreshController();
  int page = 1;
  final List<News> newsList = [];
  @override
  Future init() async {
    final list = await controller.requestNewsList(page);
    newsList.addAll(list);
    return super.init();
  }

  void onRefresh() async {
    page = 1;
    newsList.clear();
    final list = await controller.requestNewsList(page);
    newsList.addAll(list);
    refreshController.refreshCompleted();
    updateView();
  }

  void onLoadingNews() async {
    page += 1;
    final list = await controller.requestNewsList(page);
    newsList.addAll(list);
    refreshController.loadComplete();
    updateView();
  }
}
