import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/controller/stock_controller.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/util/navigator.dart';
import 'package:investing/view/stock_view/detail_view/stock_detail_view.dart';
import 'package:investing/view/stock_view/edit_view/edit_view.dart';
import 'package:investing/view/stock_view/favorite_view/favorite_view.dart';
import 'package:investing/view/stock_view/index_view/index_view.dart';
import 'package:investing/view/stock_view/search_view/stock_search_view.dart';
import 'package:investing/widget/market_status_widget.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class StockView extends ConsumerStatefulWidget {
  const StockView({super.key});

  @override
  ConsumerState<StockView> createState() => _StockViewState();
}

class _StockViewState extends ConsumerState<StockView> {
  final RefreshController refreshController = RefreshController();

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  Future<void> onRefresh() async {
    final controller = ref.read(stockControllerProvider.notifier);
    await controller.refreshFavoriteList();
    await controller.refreshIndexList();
    refreshController.refreshCompleted();
  }

  Future<void> onTapEdit(List<Stock> favoriteList) async {
    final list = await Navigator.of(context).push<List<Stock>>(
      MaterialPageRoute<List<Stock>>(
        builder: (_) => EditView(itemList: favoriteList),
      ),
    );
    if (list != null) {
      await ref.read(stockControllerProvider.notifier).updateFavoriteList(list);
    }
  }

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
  Widget build(BuildContext context) {
    final state = ref.watch(stockControllerProvider);
    final favoriteList = state.favoriteList;
    return Scaffold(
      appBar: appBar(context),
      body: SmartRefresher(
        controller: refreshController,
        enablePullDown: true,
        enablePullUp: false,
        onRefresh: onRefresh,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          physics: const BouncingScrollPhysics(),
          children: [
            IndexView(indexList: state.indexList),
            const SizedBox(height: 16.0),
            FavoriteView(
              favoriteList: favoriteList,
              onTapStock: (stock) {
                unawaited(pushView(context, StockDetailView(stock: stock)));
              },
              onTapEdit: () {
                if (favoriteList != null) {
                  unawaited(onTapEdit(favoriteList));
                }
              },
              onTapRemove: (stock) {
                unawaited(
                  ref
                      .read(stockControllerProvider.notifier)
                      .toggleFavoriteStock(stock),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
