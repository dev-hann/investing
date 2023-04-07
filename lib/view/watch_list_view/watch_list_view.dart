import 'package:get/get.dart';
import 'package:investing/controller/stock_controller.dart';
import 'package:investing/view/watch_list_view/favorite_lview/favorite_view.dart';
import 'package:investing/view/watch_list_view/index_view/index_view.dart';
import 'package:investing/view/watch_list_view/search_view/stock_search_view.dart';
import 'package:investing/view/watch_list_view/watch_list_view_model.dart';
import 'package:investing/view/view.dart';
import 'package:flutter/material.dart';

class WatchListView extends View<WatchListViewModel, StockController> {
  WatchListView({
    super.key,
  }) : super(viewModel: WatchListViewModel());

  AppBar appBar() {
    return AppBar(
      title: const Text("WatchList"),
      actions: [
        IconButton(
          onPressed: () {
            Get.to(StockSearchView());
          },
          icon: const Icon(
            Icons.search,
          ),
        ),
      ],
    );
  }

  @override
  Widget body() {
    return Scaffold(
      appBar: appBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        physics: const BouncingScrollPhysics(),
        children: [
          IndexView(
            indexList: viewModel.indexList,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FavoriteView(
              stockList: viewModel.watchList,
              onTapRemove: (stock) {
                viewModel.removeWatchList(stock);
              },
            ),
          ),
        ],
      ),
    );
  }
}
