import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:investing/controller/stock_controller.dart';
import 'package:investing/view/stock_view/favorite_lview/favorite_view.dart';
import 'package:investing/view/stock_view/index_view/index_view.dart';
import 'package:investing/view/stock_view/search_view/stock_search_view.dart';
import 'package:flutter/material.dart';
import 'package:investing/widget/market_status_widget.dart';

class StockView extends StatefulWidget {
  const StockView({super.key});

  @override
  State<StockView> createState() => _StockViewState();
}

class _StockViewState extends State<StockView> {
  final StockController controller = StockController.find();
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
