import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/controller/news_controller.dart';
import 'package:investing/model/news.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/util/navigator.dart';
import 'package:investing/view/news_view/detail_view/news_detail_view.dart';
import 'package:investing/widget/news_card.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class StockNewsDetailView extends ConsumerStatefulWidget {
  const StockNewsDetailView({super.key, required this.stock});
  final Stock stock;

  @override
  ConsumerState<StockNewsDetailView> createState() =>
      _StockNewsDetailViewState();
}

class _StockNewsDetailViewState extends ConsumerState<StockNewsDetailView> {
  final RefreshController refreshController = RefreshController();
  List<News> newsList = [];
  int page = 0;

  @override
  void initState() {
    super.initState();
    requestNextPage();
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  void refreshNewsList() {
    page = 0;
    setState(() {
      newsList = [];
    });
    requestNextPage();
  }

  void requestNextPage() async {
    page += 1;

    final list = await ref
        .read(newsControllerProvider.notifier)
        .searchStockNewsList(stock: widget.stock, page: page);
    if (mounted) {
      setState(() {
        newsList = [...newsList, ...list];
      });
    }
    refreshController
      ..loadComplete()
      ..refreshCompleted();
  }

  AppBar appBar() {
    return AppBar(title: const Text('News View'));
  }

  @override
  Widget build(BuildContext context) {
    final list = newsList;
    return Scaffold(
      appBar: appBar(),
      body: SmartRefresher(
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
                      unawaited(pushView(context, NewsDetailView(news: news)));
                    },
                    news: news,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
