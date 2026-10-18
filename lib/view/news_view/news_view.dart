import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investing/controller/news_controller.dart';
import 'package:investing/view/news_view/detail_view/news_detail_view.dart';
import 'package:investing/view/news_view/search_view.dart/news_search_view.dart';
import 'package:investing/widget/news_card.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class NewsView extends StatefulWidget {
  const NewsView({super.key});

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  final NewsController controller = NewsController.find();

  AppBar appBar() {
    return AppBar(
      title: const Text('News'),
      actions: [
        IconButton(
          onPressed: () {
            unawaited(Get.to<void>(const NewsSearchView()));
          },
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        onLoading: controller.requestNextPageNewsList,
        onRefresh: controller.refreshNewsList,
        controller: controller.refreshController,
        child: GetBuilder<NewsController>(
          builder: (controller) {
            final list = controller.newsList;
            return ListView.builder(
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
                          unawaited(Get.to<void>(NewsDetailView(news: news)));
                        },
                        news: news,
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
