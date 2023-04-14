import 'package:flutter/material.dart';
import 'package:investing/model/stock.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(stock.percentageChange),
        Text(stock.lastSalePrice),
      ],
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
