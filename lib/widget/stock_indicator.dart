import 'package:flutter/material.dart';
import 'package:investing/model/stock.dart';

class StockIndicator extends StatelessWidget {
  const StockIndicator({
    super.key,
    required this.stock,
    this.style,
  });
  final Stock stock;
  final TextStyle? style;
  bool get isUp => stock.deltaIndicator == "up";

  @override
  Widget build(BuildContext context) {
    return Text(
      isUp ? "▲" : "▼",
      style: style,
    );
  }
}
