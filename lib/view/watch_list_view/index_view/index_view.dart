import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investing/const/color.dart';
import 'package:investing/model/stock.dart';
import 'package:investing/view/watch_list_view/detail_view/stock_detail_view.dart';
import 'package:investing/widget/chart_widget.dart';
import 'package:investing/widget/stock_price_text.dart';
import 'package:investing/widget/title_widget.dart';

class IndexView extends StatelessWidget {
  const IndexView({
    super.key,
    required this.indexList,
  });
  final List<Stock> indexList;

  Widget item(Stock index) {
    return GestureDetector(
      onTap: () {
        Get.to(
          StockDetailView(stock: index),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: IVColor.blueGrey,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: SizedBox(
            width: Get.width / 2.5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Builder(
                builder: (context) {
                  final textTheme = Theme.of(context).textTheme;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IgnorePointer(
                        child: IVChartWidget(
                          stock: index,
                        ),
                      ),
                      AutoSizeText(
                        index.name,
                        maxLines: 1,
                        // style: textTheme.bodySmall,
                      ),
                      Text(
                        index.lastSalePrice,
                        style: textTheme.titleMedium,
                      ),
                      IVStockPriceText(stock: index),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final itemList = indexList;
    return TitleWidget(
      title: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text("Index"),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: itemList.map(item).toList(),
        ),
      ),
    );
  }
}
