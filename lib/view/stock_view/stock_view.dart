import 'package:get/get.dart';
import 'package:investing/controller/stock_controller.dart';
import 'package:investing/view/stock_view/detail_view/stock_detail_view.dart';
import 'package:investing/view/stock_view/favorite_view/favorite_view.dart';
import 'package:investing/view/stock_view/index_view/index_view.dart';
import 'package:investing/view/stock_view/search_view/stock_search_view.dart';
import 'package:flutter/material.dart';
import 'package:investing/widget/market_status_widget.dart';

class StockView extends StatelessWidget {
  const StockView({super.key});

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
      body: GetBuilder<StockController>(builder: (controller) {
        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          physics: const BouncingScrollPhysics(),
          children: [
            IndexView(
              indexList: controller.indexList,
            ),
            const SizedBox(height: 16.0),
            FavoriteView(
              favoriteList: controller.favoriteList,
              onTapStock: (stock) {
                Get.to(
                  StockDetailView(stock: stock),
                );
              },
              onTapEdit: () {},
              onTapRemove: (stock) {},
            ),
          ],
        );
      }),
    );
  }
}
