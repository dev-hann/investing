import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investing/const/color.dart';
import 'package:investing/controller/stock_controller.dart';
import 'package:investing/model/stock.dart';
import 'package:investing/view/view.dart';
import 'package:investing/view/watch_list_view/detail_view/stock_detail_view.dart';
import 'package:investing/view/watch_list_view/favorite_lview/favorite_view_model.dart';
import 'package:investing/view/watch_list_view/search_view/stock_search_view.dart';
import 'package:investing/widget/stock_card.dart';
import 'package:investing/widget/title_widget.dart';

class FavoriteView extends View<FavoriteViewModel, StockController> {
  FavoriteView({
    super.key,
  }) : super(viewModel: FavoriteViewModel());

  @override
  Widget body() {
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
            child: const Icon(
              Icons.settings,
              color: IVColor.orange,
            ),
          ),
        ],
      ),
      child: ListView.separated(
        reverse: true,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return const SizedBox(height: 8.0);
        },
        itemCount: 10,
        itemBuilder: (context, index) {
          final stock = Stock(
            name: "name$index",
            symbol: "symbol",
            count: 5 * index,
            price: 100,
            dividendYield: 0.5,
            stockTypeIndex: 0,
          );
          return StockCard(
            stock: stock,
            onTap: () {
              Get.to(
                StockDetailView(stock: stock),
              );
            },
            onTapRemove: () {
              // viewModel.removeStock(stock);
            },
          );
        },
        // onReorder: viewModel.reorder,
      ),
    );
  }
}
