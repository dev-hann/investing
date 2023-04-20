import 'package:get/get.dart';
import 'package:investing/view/watch_list_view/favorite_lview/favorite_view.dart';
import 'package:investing/view/watch_list_view/index_view/index_view.dart';
import 'package:investing/view/watch_list_view/search_view/stock_search_view.dart';
import 'package:flutter/material.dart';
import 'package:investing/widget/market_status_widget.dart';

class WatchListView extends StatelessWidget {
  const WatchListView({super.key});

  AppBar appBar() {
    return AppBar(
      title: const Text("WatchList"),
      leading: const MarketStatusWidget(),
      actions: [
        IconButton(
          onPressed: () {
            Get.to(const StockSearchView());
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
        children: const [
          IndexView(),
          SizedBox(height: 16.0),
          FavoriteView(),
        ],
      ),
    );
  }
}
