import 'package:dividends_manager/controller/news_controller.dart';
import 'package:dividends_manager/view/news_view/news_view_model.dart';
import 'package:dividends_manager/view/view.dart';
import 'package:flutter/material.dart';

class NewsView extends View<NewsViewModel, NewsController> {
  NewsView({super.key}) : super(viewModel: NewsViewModel());
  AppBar appBar() {
    return AppBar(
      title: const Text("News"),
    );
  }

  @override
  Widget body() {
    return Scaffold(
      appBar: appBar(),
    );
  }
}
