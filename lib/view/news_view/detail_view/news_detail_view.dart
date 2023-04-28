import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:investing/model/news.dart';

class NewsDetailView extends StatelessWidget {
  const NewsDetailView({
    super.key,
    required this.news,
  });
  final News news;

  AppBar appBar() {
    return AppBar(
      title: const Text("News Detail View"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          url: Uri.parse(news.articleDetailURL),
        ),
      ),
    );
  }
}
