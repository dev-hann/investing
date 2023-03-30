import 'package:flutter/material.dart';
import 'package:investing/const/color.dart';

class StockPriceText extends StatelessWidget {
  const StockPriceText({
    super.key,
    required this.closedPrice,
    required this.currentPrice,
  });
  final double closedPrice;
  final double currentPrice;
  bool get isUp => currentPrice > closedPrice;
  double get incomePrice => (closedPrice - currentPrice).abs();
  double get percent => (incomePrice / closedPrice).abs();

  @override
  Widget build(BuildContext context) {
    return Text(
      "${isUp ? "▲" : "▼"}${percent.toStringAsFixed(2)}% (${incomePrice.toStringAsFixed(2)})",
      style: TextStyle(
        color: isUp ? IVColor.red : IVColor.blue,
      ),
    );
  }
}
