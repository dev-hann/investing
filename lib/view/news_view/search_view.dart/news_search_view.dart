import 'package:dividends_manager/controller/news_controller.dart';
import 'package:dividends_manager/view/news_view/search_view.dart/news_search_view_model.dart';
import 'package:dividends_manager/view/view.dart';
import 'package:dividends_manager/widget/news_card.dart';
import 'package:dividends_manager/widget/text_field.dart';
import 'package:flutter/material.dart';

class NewsSearchView extends View<NewsSearchViewModel, NewsController> {
  NewsSearchView({super.key}) : super(viewModel: NewsSearchViewModel());

  AppBar appBar() {
    return AppBar(
      title: const Text("Search News"),
    );
  }

  Widget queryTextField() {
    return Card(
      child: CustomTextfield(
        controller: viewModel.queryCntroller,
        onChanged: viewModel.queryValue,
        onSubmitted: (text) {
          viewModel.searchNews(text);
        },
        hintText: "Aa",
      ),
    );
  }

  Widget searchedListWidget() {
    final searchedList = viewModel.searchedList;
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
  Widget body() {
    return Scaffold(
      appBar: appBar(),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        physics: const BouncingScrollPhysics(),
        children: [
          queryTextField(),
          const SizedBox(height: 16.0),
          searchedListWidget(),
        ],
      ),
    );
  }
}
