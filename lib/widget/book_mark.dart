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
    final controller = StockController.find();
    return Obx(() {
      final favoriteList = controller.favoriteList;
      final isContains = favoriteList.indexWhere(
            (element) {
              return element.isEquals(stock);
            },
          ) !=
          -1;
      return GestureDetector(
        onTap: () {
          if (isContains) {
            controller.removeFavoriteStock(stock);
          } else {
            controller.updateFavoriteStock(stock);
          }
        },
        child: Icon(
          isContains ? Icons.bookmark : Icons.bookmark_border,
          color: isContains ? activeColor : color,
        ),
      );
    });
  }
}
