import 'package:investing/controller/watch_list_controller.dart';
import 'package:investing/view/watch_list_view/detail_view/stock_detail_view.dart';
import 'package:investing/view/watch_list_view/search_view/stock_search_view.dart';
import 'package:investing/view/watch_list_view/watch_list_view_model.dart';
import 'package:investing/widget/stock_card.dart';
import 'package:investing/view/view.dart';
import 'package:investing/widget/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WatchListView extends View<WatchListViewModel, WatchListController> {
  WatchListView({
    super.key,
  }) : super(viewModel: WatchListViewModel());

  AppBar appBar() {
    return AppBar(
      title: const Text("WatchList"),
    );
  }

  Widget monthlyDividendsWidget() {
    return const TitleWidget(
      title: Text("배당 정보"),
      child: Card(
        child: SizedBox(
          height: kToolbarHeight * 2,
          child: Center(
            child: Text("@#@#"),
          ),
        ),
      ),
    );
  }

  Widget stockListWidget() {
    final list = viewModel.stockList;
    return TitleWidget(
      title: Row(
        children: [
          const Expanded(child: Text("Favorites")),
          GestureDetector(
            onTap: () {
              Get.to(
                StockSearchView(),
              );
            },
            child: Row(
              children: const [
                Text(
                  "종목 추가",
                  style: TextStyle(
                    color: Colors.orangeAccent,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 8.0,
                  color: Colors.orangeAccent,
                )
              ],
            ),
          ),
        ],
      ),
      child: ListView.builder(
        reverse: true,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          final stock = list[index];
          return Padding(
            key: ValueKey(index),
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: StockCard(
              stock: stock,
              onTap: () {
                Get.to(
                  StockDetailView(stock: stock),
                );
              },
              onTapRemove: () {
                viewModel.removeStock(stock);
              },
            ),
          );
        },
        // onReorder: viewModel.reorder,
      ),
    );
  }

  @override
  Widget body() {
    return Scaffold(
      appBar: appBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 32.0,
        ),
        physics: const BouncingScrollPhysics(),
        children: [
          stockListWidget(),
        ],
      ),
    );
  }
}
