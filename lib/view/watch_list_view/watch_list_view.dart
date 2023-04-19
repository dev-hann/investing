import 'package:get/get.dart';
import 'package:investing/controller/stock_controller.dart';
import 'package:investing/view/view.dart';
import 'package:investing/view/watch_list_view/favorite_lview/favorite_view.dart';
import 'package:investing/view/watch_list_view/index_view/index_view.dart';
import 'package:investing/view/watch_list_view/search_view/stock_search_view.dart';
import 'package:flutter/material.dart';
import 'package:investing/view/watch_list_view/watch_list_view_model.dart';
import 'package:investing/widget/market_status_widget.dart';

class WatchListView extends View<WatchListViewModel, StockController> {
  WatchListView({
    super.key,
  }) : super(viewModel: WatchListViewModel());

  AppBar appBar() {
    return AppBar(
      title: const Text("WatchList"),
      leading: MarketStatusWidget(
        status: viewModel.marketStatus,
      ),
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
          childBuilder(
            childViewID: viewModel.indexViewID,
            child: IndexView(
              indexDetailList: viewModel.indexDetailList,
            ),
          ),
          childBuilder(
            childViewID: viewModel.favoriteViewID,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: FavoriteView(
                favoriteList: viewModel.favoriteList,
                onTapRemove: viewModel.onTapRemoveStock,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
