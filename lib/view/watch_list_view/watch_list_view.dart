import 'package:get/get.dart';
import 'package:investing/view/watch_list_view/favorite_lview/favorite_view.dart';
import 'package:investing/view/watch_list_view/index_view/index_view.dart';
import 'package:investing/view/watch_list_view/search_view/stock_search_view.dart';
import 'package:flutter/material.dart';

class WatchListView extends StatelessWidget {
  const WatchListView({
    super.key,
  });

  AppBar appBar() {
    return AppBar(
      title: const Text("WatchList"),
      // leading: MarketStatusWidget(
      //   status: viewModel.marketStatus,
      // ),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        physics: const BouncingScrollPhysics(),
        children: [
          IndexView(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FavoriteView(),
          ),
        ],
      ),
    );
  }
}
