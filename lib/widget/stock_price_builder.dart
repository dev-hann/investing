import 'package:flutter/material.dart';
import 'package:investing/const/color.dart';
import 'package:investing/model/stock.dart';
import 'package:investing/util/number_format.dart';

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
  TextStyle get style {
    switch (stock.indicatorStatus) {
      case IndicatorStatus.up:
        return const TextStyle(color: IVColor.red);
      case IndicatorStatus.down:
        return const TextStyle(color: IVColor.blue);
      case IndicatorStatus.same:
        return const TextStyle(color: IVColor.grey);
    }
  }

  String indicatorText() {
    switch (stock.indicatorStatus) {
      case IndicatorStatus.up:
        return "▲";
      case IndicatorStatus.down:
        return "▼";
      case IndicatorStatus.same:
        return "-";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (stock.isEmpty) {
      return const SizedBox();
    }
    final netChange = stock.netChange;
    final netChagneText = netChangeBracket ? "($netChange)" : "$netChange";
    String percentageChangText = "${stock.percentChange}%";
    final lastPriceText = IVNumberFormat.priceFormat(stock.lastSalePrice);
    return builder(
      Text(indicatorText(), style: indicatorStyle ?? style),
      Text(percentageChangText, style: percentageStyle ?? style),
      Text(netChagneText, style: netChangeStyle ?? style),
      Text(lastPriceText, style: lastPriceStyle ?? style),
    );
  }
}
