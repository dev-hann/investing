import 'package:investing/controller/news_controller.dart';
import 'package:investing/view/news_view/detail_view/news_detail_view.dart';
import 'package:investing/widget/news_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NewsView extends StatefulWidget {
  const NewsView({
    super.key,
  });

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  final NewsController controller = NewsController.find();

  @override
  void initState() {
    super.initState();
  }

  AppBar appBar() {
    return AppBar(
      title: const Text("News"),
      actions: [
        IconButton(
          onPressed: () {
            // Get.to(NewsSearchView());
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
      body: Obx(() {
        final list = controller.newsList;
        return SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          onLoading: controller.requestNextPageNewsList,
          onRefresh: controller.refreshNewsList,
          controller: controller.refreshController,
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
                        Get.to(
                          NewsDetailView(
                            url: news.articleDetailURL,
                          ),
                        );
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
