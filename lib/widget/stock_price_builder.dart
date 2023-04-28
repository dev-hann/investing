import 'package:flutter/material.dart';
import 'package:investing/const/color.dart';
import 'package:investing/model/stock/stock.dart';

typedef PriceWidgetBuilder = Widget Function(
  String indicator,
  double percentageChange,
  double netChage,
  double lastPrice,
);

class IVStockPriceBuilder extends StatelessWidget {
  const IVStockPriceBuilder({
    super.key,
    required this.stock,
    required this.builder,
  });
  final Stock stock;
  final PriceWidgetBuilder builder;
  TextStyle get style {
    switch (stock.indicatorStatus) {
      case IndicatorStatus.up:
        return const TextStyle(color: IVColor.darkRed);
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
    return DefaultTextStyle(
      style: style,
      child: builder(
        indicatorText(),
        stock.percentChange,
        stock.netChange,
        stock.lastSalePrice,
      ),
    );
  }
}
