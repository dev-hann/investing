import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:investing/controller/stock_controller.dart';
import 'package:investing/view/view.dart';
import 'package:investing/view/watch_list_view/detail_view/stock_detail_view.dart';
import 'package:investing/view/watch_list_view/favorite_lview/favorite_view_model.dart';
import 'package:investing/widget/stock_card.dart';
import 'package:investing/widget/title_widget.dart';

class FavoriteView extends View<FavoriteViewModel, StockController> {
  FavoriteView({super.key})
      : super(
          viewModel: FavoriteViewModel(),
        );

  @override
  Widget body() {
    final stockList = viewModel.favoriteStockList;
    return TitleWidget(
      title: const Text("Favorites"),
      child: ListView.separated(
        reverse: true,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          return const SizedBox(height: 8.0);
        },
        itemCount: stockList.length,
        itemBuilder: (context, index) {
          final stock = stockList[index];
          return Slidable(
            endActionPane: ActionPane(
              motion: const BehindMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {},
                  backgroundColor: const Color(0xFF21B7CA),
                  foregroundColor: Colors.white,
                  icon: Icons.share,
                  label: 'Share',
                ),
                SlidableAction(
                  onPressed: (context) {
                    viewModel.onTapRemoveStock(stock);
                  },
                  backgroundColor: const Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: StockCard(
              stock: stock,
              onTap: () {
                Get.to(
                  StockDetailView(stock: stock),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
