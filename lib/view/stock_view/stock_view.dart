import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/controller/stock_controller.dart';
import 'package:investing/util/navigator.dart';
import 'package:investing/view/stock_view/detail_view/stock_detail_view.dart';
import 'package:investing/view/stock_view/favorite_view/favorite_view.dart';
import 'package:investing/view/stock_view/index_view/index_view.dart';
import 'package:investing/view/stock_view/search_view/stock_search_view.dart';
import 'package:investing/widget/market_status_widget.dart';

class StockView extends ConsumerWidget {
  const StockView({super.key});

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: const Text('WatchList'),
      leading: const MarketStatusWidget(),
      actions: [
        IconButton(
          onPressed: () {
            unawaited(pushView(context, const StockSearchView()));
          },
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stockControllerProvider);
    return Scaffold(
      appBar: appBar(context),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        physics: const BouncingScrollPhysics(),
        children: [
          IndexView(indexList: state.indexList),
          const SizedBox(height: 16.0),
          FavoriteView(
            favoriteList: state.favoriteList,
            onTapStock: (stock) {
              unawaited(pushView(context, StockDetailView(stock: stock)));
            },
            onTapEdit: () {},
            onTapRemove: (stock) {},
          ),
        ],
      ),
    );
  }
}
