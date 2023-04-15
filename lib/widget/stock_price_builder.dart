import 'package:flutter/material.dart';
import 'package:investing/const/color.dart';
import 'package:investing/model/stock.dart';
import 'package:investing/widget/stock_indicator.dart';

typedef PriceWidgetBuilder = Widget Function(
  Widget indicator,
  Widget percentageChange,
  Widget netChage,
  Widget lastPrice,
);

class IVStockPriceBuilder extends StatelessWidget {
  const IVStockPriceBuilder({
    super.key,
    required this.stock,
    required this.builder,
    this.indicatorStyle,
    this.percentageStyle,
    this.netChangeStyle,
    this.lastPriceStyle,
    this.netChangeBracket = false,
  });
  final Stock stock;
  final PriceWidgetBuilder builder;
  final TextStyle? indicatorStyle;
  final TextStyle? percentageStyle;
  final TextStyle? netChangeStyle;
  final TextStyle? lastPriceStyle;
  final bool netChangeBracket;

  @override
  Widget build(BuildContext context) {
    if (stock.isEmpty) {
      return const SizedBox();
    }

    final isUp = stock.deltaIndicator == "up";
    final netChange =
        netChangeBracket ? "(${stock.netChange})" : stock.netChange;
    final percentageChange = stock.percentageChange;
    String percentageChangText =
        percentageChange.isEmpty ? "0%" : percentageChange;
    final lastPriceText = stock.lastSalePrice;
    final style = TextStyle(
      color: isUp ? IVColor.red : IVColor.blue,
    );
    return builder(
      StockIndicator(stock: stock, style: indicatorStyle ?? style),
      Text(percentageChangText, style: percentageStyle ?? style),
      Text(netChange, style: netChangeStyle ?? style),
      Text(lastPriceText, style: lastPriceStyle ?? style),
    );
  }
}
