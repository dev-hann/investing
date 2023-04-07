import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investing/const/color.dart';
import 'package:investing/model/stock.dart';
import 'package:investing/widget/stock_price_text.dart';
import 'package:investing/widget/title_widget.dart';

// S&P500, Nasdaq, Dow, Gold, Oil, Dollar,
class IndexView extends StatelessWidget {
  const IndexView({
    super.key,
    required this.indexList,
  });
  final List<Stock> indexList;

  double get size => Get.width / 2.5;

  Widget item(Stock stock) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: IVColor.blueGrey,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: SizedBox(
        width: size,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Builder(builder: (context) {
            final textTheme = Theme.of(context).textTheme;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "15분 지연",
                  style: textTheme.labelMedium,
                ),
                const Expanded(
                  child: ColoredBox(
                    color: Colors.white,
                    // child: Center(),
                  ),
                ),
                Text(
                  stock.name,
                  style: textTheme.bodyMedium,
                ),
                Text(
                  stock.priceText,
                  style: textTheme.titleMedium,
                ),
                StockPriceText(
                  closedPrice: 20,
                  currentPrice: stock.price,
                ),
              ],
            );
          }),
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
      child: SizedBox(
        height: size * 1.1,
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          itemCount: itemList.length,
          scrollDirection: Axis.horizontal,
          separatorBuilder: (context, index) {
            return const SizedBox(width: 8.0);
          },
          itemBuilder: (context, index) {
            return item(itemList[index]);
          },
        ),
      ),
    );
  }
}
