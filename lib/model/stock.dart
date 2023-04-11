import 'package:equatable/equatable.dart';
import 'package:investing/model/chart.dart';
import 'package:investing/model/date_time_range.dart';

enum StockType {
  majorIndex,
  finxedIncome,
  commodity,
  etf,
  stock,
}

abstract class Stock extends Equatable {
  const Stock({
    required this.symbol,
    required this.name,
    required this.lastSalePrice,
    required this.netChange,
    required this.percentageChange,
    required this.chartList,
    required this.type,
  });
  final String symbol;
  final String name;
  final String lastSalePrice;
  final String netChange;
  final String percentageChange;
  final List<IVChart> chartList;
  final StockType type;

  String get assetClass {
    switch (type) {
      case StockType.majorIndex:
        return "index";
      case StockType.finxedIncome:
        return "fixedincome";
      case StockType.commodity:
        return "commodities";
      case StockType.etf:
        return "etf";
      case StockType.stock:
        return "stocks";
    }
  }

  List<IVDateTimeRange?> get dateTimeRangeList {
    final list = <IVDateTimeRange?>[
      IVDateTimeRange.beforeDay(7),
      IVDateTimeRange.beforeMonth(1),
      IVDateTimeRange.beforeMonth(3),
      IVDateTimeRange.beforeYear(1),
      IVDateTimeRange.beforeYear(100),
    ];
    switch (type) {
      case StockType.majorIndex:
      case StockType.stock:
        return [null, ...list];
      case StockType.finxedIncome:
      case StockType.commodity:
      case StockType.etf:
        return list;
    }
  }
}
