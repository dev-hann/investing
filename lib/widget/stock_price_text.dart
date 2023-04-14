import 'package:flutter/material.dart';
import 'package:investing/const/color.dart';
import 'package:investing/model/stock.dart';

class IVStockPriceText extends StatelessWidget {
  const IVStockPriceText({
    super.key,
    required this.stock,
  });
  final Stock stock;

  @override
  Widget build(BuildContext context) {
    if (stock.isEmpty) {
      return const SizedBox();
    }

    final isUp = stock.deltaIndicator == "up";
    final netChange = stock.netChange;
    final percentageChange = stock.percentageChange;
    final percentageChangText =
        percentageChange.isEmpty ? "0%" : percentageChange;

    return Text(
      "${isUp ? "▲" : "▼"} $percentageChangText ($netChange)",
      style: TextStyle(
        color: isUp ? IVColor.red : IVColor.blue,
      ),
    );
  }
}
