import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investing/controller/stock_controller.dart';
import 'package:investing/model/stock/stock.dart';

class BookMarkWidget extends StatelessWidget {
  const BookMarkWidget({
    super.key,
    required this.stock,
    this.activeColor = Colors.orangeAccent,
    this.color = Colors.white,
  });
  final Stock stock;
  final Color activeColor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StockController>(
      builder: (controller) {
        final isContains = controller.isContains(stock);
        return GestureDetector(
          onTap: () {
            controller.toggleFavoriteStock(stock);
          },
          child: Icon(
            isContains ? Icons.bookmark : Icons.bookmark_border,
            color: isContains ? activeColor : color,
          ),
        );
      },
    );
  }
}
