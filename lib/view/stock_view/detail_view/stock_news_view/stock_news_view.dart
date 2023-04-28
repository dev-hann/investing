import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investing/controller/news_controller.dart';
import 'package:investing/model/news.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/view/news_view/detail_view/news_detail_view.dart';
import 'package:investing/widget/title_widget.dart';

class StockNewsView extends StatefulWidget {
  const StockNewsView({
    super.key,
    required this.stock,
  });
  final Stock stock;

  @override
  State<StockNewsView> createState() => _StockNewsViewState();
}

class _StockNewsViewState extends State<StockNewsView> {
  final NewsController controller = NewsController.find();
  final RxList<News> newsList = RxList();

  @override
  void initState() {
    super.initState();
    controller
        .searchStockNewsList(
          stock: widget.stock,
          page: 1,
        )
        .then(newsList);
  }

  Widget item(News news) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Card(
        child: ListTile(
          onTap: () {
            Get.to(NewsDetailView(news: news));
          },
          title: Text(
            news.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(news.ago ?? ""),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = newsList;
      if (list.isEmpty) {
        return const SizedBox();
      }
      return Column(
        children: [
          TitleWidget(
            title: const Text("News"),
            child: Column(
              children: newsList.sublist(0, 3).map(item).toList(),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text("More"),
          ),
        ],
      );
    });
  }
}
