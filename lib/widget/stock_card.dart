import 'package:flutter/material.dart';
import 'package:investing/model/stock.dart';
import 'package:investing/widget/stock_price_builder.dart';

class StockCard extends StatelessWidget {
  const StockCard({
    super.key,
    required this.stock,
    required this.onTap,
  });
  final Stock stock;
  final VoidCallback onTap;

  Widget titleText() {
    return Text(
      stock.name,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget subtitleText() {
    return Text(stock.symbol);
  }

  Widget trailingWidget() {
    return IVStockPriceBuilder(
      stock: stock,
      builder: (indicator, percentageChange, netChage, lastPrice) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IntrinsicWidth(
              child: Row(
                children: [indicator, percentageChange],
              ),
            ),
            lastPrice,
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: ListTile(
          title: titleText(),
          subtitle: subtitleText(),
          trailing: trailingWidget(),
        ),
      ),
    );
  }
}
