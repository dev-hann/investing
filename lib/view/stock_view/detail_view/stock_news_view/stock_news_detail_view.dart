import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investing/controller/news_controller.dart';
import 'package:investing/model/news.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/view/news_view/detail_view/news_detail_view.dart';
import 'package:investing/widget/news_card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class StockNewsDetailView extends StatefulWidget {
  const StockNewsDetailView({
    super.key,
    required this.stock,
  });
  final Stock stock;

  @override
  State<StockNewsDetailView> createState() => _StockNewsDetailViewState();
}

class _StockNewsDetailViewState extends State<StockNewsDetailView> {
  final NewsController controller = NewsController.find();
  final RefreshController refreshController = RefreshController();
  final RxList<News> newsList = RxList();
  int page = 0;

  @override
  void initState() {
    super.initState();
    requestNextPage();
  }

  void refreshNewsList() {
    page = 0;
    newsList.clear();
    requestNextPage();
  }

  void requestNextPage() async {
    page += 1;

    final list = await controller.searchStockNewsList(
      stock: widget.stock,
      page: page,
    );
    newsList.addAll(list);
    refreshController.loadComplete();
    refreshController.refreshCompleted();
  }

  AppBar appBar() {
    return AppBar(
      title: const Text("News View"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Obx(() {
        final list = newsList;
        return SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: refreshNewsList,
          onLoading: requestNextPage,
          controller: refreshController,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final news = list[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: NewsCard(
                      onTap: () {
                        Get.to(NewsDetailView(news: news));
                      },
                      news: news,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
