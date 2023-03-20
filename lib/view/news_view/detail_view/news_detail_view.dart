import 'package:dividends_manager/controller/news_controller.dart';
import 'package:dividends_manager/model/news.dart';
import 'package:dividends_manager/view/news_view/detail_view/news_detail_view_model.dart';
import 'package:dividends_manager/view/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

class NewsDetailView extends View<NewsDetailViewModel, NewsController> {
  NewsDetailView({
    super.key,
    required News news,
  }) : super(viewModel: NewsDetailViewModel(news));

  AppBar appBar() {
    return AppBar(
      title: const Text("News Detail"),
    );
  }

  Widget titleWidget() {
    return Text(viewModel.titleText);
  }

  @override
  Widget body() {
    return Scaffold(
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            titleWidget(),
            Html(
              data: viewModel.bodyHtml,
              onLinkTap: (String? url, RenderContext context,
                  Map<String, String> attributes, dom.Element? element) {},
            ),
          ],
        ),
      ),
    );
  }
}
