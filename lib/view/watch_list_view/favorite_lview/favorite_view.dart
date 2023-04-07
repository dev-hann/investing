import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investing/model/stock.dart';
import 'package:investing/view/watch_list_view/detail_view/stock_detail_view.dart';
import 'package:investing/widget/stock_card.dart';
import 'package:investing/widget/title_widget.dart';

class FavoriteView extends StatelessWidget {
  const FavoriteView({
    super.key,
    required this.stockList,
    required this.onTapRemove,
  });
  final List<Stock> stockList;
  final Function(Stock stock) onTapRemove;

  @override
  Widget build(BuildContext context) {
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
          return StockCard(
            stock: stock,
            onTap: () {
              Get.to(
                StockDetailView(stock: stock),
              );
            },
            onTapRemove: () {
              onTapRemove(stock);
            },
          );
        },
      ),
    );
  }
}
