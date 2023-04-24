import 'package:get/get.dart';
import 'package:investing/controller/news_controller.dart';
import 'package:investing/model/news.dart';
import 'package:investing/widget/news_card.dart';
import 'package:investing/widget/text_field.dart';
import 'package:flutter/material.dart';

class NewsSearchView extends StatefulWidget {
  const NewsSearchView({super.key});

  @override
  State<NewsSearchView> createState() => _NewsSearchViewState();
}

class _NewsSearchViewState extends State<NewsSearchView> {
  final NewsController controller = NewsController.find();

  AppBar appBar() {
    return AppBar(
      title: const Text("Search News"),
    );
  }

  Widget queryTextField({
    required Function(String query) onSubmitted,
  }) {
    return Card(
      child: CustomTextfield(
        onSubmitted: onSubmitted,
        hintText: "Aa",
      ),
    );
  }

  Widget searchedListWidget({
    required List<News> searchedList,
  }) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: searchedList.length,
      itemBuilder: (context, index) {
        final news = searchedList[index];
        return NewsCard(
          news: news,
          onTap: () async {
            // Get.to(
            //   StockDetailView(stock: news),
            // );
          },
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 16.0);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Obx(() {
        return ListView(
          padding: const EdgeInsets.all(16.0),
          physics: const BouncingScrollPhysics(),
          children: [
            queryTextField(
              onSubmitted: (query) {
                controller.searchNews(query);
              },
            ),
            const SizedBox(height: 16.0),
            searchedListWidget(
              searchedList: controller.searchedList,
            ),
          ],
        );
      }),
    );
  }
}
