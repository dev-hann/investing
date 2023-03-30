import 'package:investing/model/stock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:investing/widget/stock_price_text.dart';

class StockCard extends StatelessWidget {
  const StockCard({
    super.key,
    required this.stock,
    required this.onTap,
    required this.onTapRemove,
    this.enableSlide = true,
  });
  final Stock stock;
  final VoidCallback onTap;
  final VoidCallback onTapRemove;
  final bool enableSlide;

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

  Widget trailingText() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text("${stock.count}원"),
        Text("예상 배당률 ${stock.dividendYield}%"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: Slidable(
          enabled: enableSlide,
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
                  onTapRemove();
                },
                backgroundColor: const Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: ListTile(
            title: titleText(),
            subtitle: subtitleText(),
            trailing: const StockPriceText(
              closedPrice: 102,
              currentPrice: 101.1,
            ),
          ),
        ),
      ),
    );
  }
}
