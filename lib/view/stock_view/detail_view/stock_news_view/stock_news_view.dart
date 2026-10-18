import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/controller/news_controller.dart';
import 'package:investing/model/news.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/util/navigator.dart';
import 'package:investing/view/news_view/detail_view/news_detail_view.dart';
import 'package:investing/view/stock_view/detail_view/stock_news_view/stock_news_detail_view.dart';
import 'package:investing/widget/text_button.dart';
import 'package:investing/widget/title_widget.dart';

class StockNewsView extends ConsumerStatefulWidget {
  const StockNewsView({super.key, required this.stock});
  final Stock stock;

  @override
  ConsumerState<StockNewsView> createState() => _StockNewsViewState();
}

class _StockNewsViewState extends ConsumerState<StockNewsView> {
  List<News> newsList = [];

  @override
  void initState() {
    super.initState();
    unawaited(_requestNewsList());
  }

  Future<void> _requestNewsList() async {
    final list = await ref
        .read(newsControllerProvider.notifier)
        .searchStockNewsList(stock: widget.stock, page: 1);
    if (mounted) {
      setState(() {
        newsList = list;
      });
    }
  }

  Widget item(BuildContext context, News news) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Card(
        child: ListTile(
          onTap: () {
            unawaited(pushView(context, NewsDetailView(news: news)));
          },
          title: Text(news.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text(news.created ?? ''),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (newsList.isEmpty) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          TitleWidget.withButton(
            title: const Text('News'),
            trailing: IVTextButton.more(
              onTap: () {
                unawaited(
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return StockNewsDetailView(stock: widget.stock);
                    },
                  ),
                );
              },
            ),
            child: Column(
              children: newsList
                  .sublist(0, 3)
                  .map((e) => item(context, e))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
