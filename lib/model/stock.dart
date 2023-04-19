import 'package:equatable/equatable.dart';

import 'package:investing/data/db/data_base_model_mixin.dart';
import 'package:investing/model/date_time_range.dart';

enum IndicatorStatus {
  up,
  down,
  same,
}

class Stock extends Equatable with DataBaseModelMixin, Comparable<Stock> {
  Stock({
    required this.symbol,
    required this.name,
    required this.asset,
    this.lastSalePrice = 0.0,
    this.netChange = 0.0,
    this.percentChange = 0.0,
  });

  final String symbol;
  final String name;
  final double lastSalePrice;
  final double netChange;
  final double percentChange;
  final String asset;

  bool get isEmpty {
    return lastSalePrice == 0 && netChange == 0 && percentChange == 0;
  }

  IndicatorStatus get indicatorStatus {
    if (netChange == 0) {
      return IndicatorStatus.same;
    }
    if (netChange > 0) {
      return IndicatorStatus.up;
    }
    return IndicatorStatus.down;
  }

  List<IVDateTimeRange?> get dateTimeRangeList {
    final list = <IVDateTimeRange?>[
      IVDateTimeRange.beforeDay(7),
      IVDateTimeRange.beforeMonth(1),
      IVDateTimeRange.beforeMonth(3),
      IVDateTimeRange.beforeYear(1),
      IVDateTimeRange.beforeYear(100),
    ];
    // final assetValue = asset.toLowerCase();
    // if (assetValue == "index" || assetValue == "stocks") {
    //   return [null, IVDateTimeRange.beforeDay(1), ...list];
    // }
    return list;
  }

  bool get i {
    return lastSalePrice == 0 && netChange == 0 && percentChange == 0;
  }

  get change => null;

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'symbol': symbol,
      'asset': asset,
    };
  }

  bool isEquals(Stock other) {
    return symbol == other.symbol;
  }

  @override
  List<Object?> get props => [
        symbol,
      ];

  @override
  String get index => symbol;

  factory Stock.snp() {
    return Stock(
      symbol: "SPX",
      name: "S&P 500",
      asset: "index",
    );
  }

  factory Stock.dow() {
    return Stock(
      symbol: "INDU",
      name: "DOW",
      asset: "index",
    );
  }

  factory Stock.nasdaq() {
    return Stock(
      symbol: "COMP",
      name: "Nasdaq",
      asset: "index",
    );
  }
  factory Stock.treasury2Y() {
    return Stock(
        symbol: "CMTN2Y", name: "2 Years Treasury", asset: "fixedincome");
  }
  factory Stock.treasury20Y() {
    return Stock(
      symbol: "CMTN2Y",
      name: "20 Years Treasury",
      asset: "fixedincome",
    );
  }
  factory Stock.crudeOil() {
    return Stock(
      symbol: "CL%3ANMX",
      name: "WTI Oil",
      asset: "commodities",
    );
  }

  factory Stock.gold() {
    return Stock(
      symbol: "GC%3ACMX",
      name: "Gold",
      asset: "commodities",
    );
  }
  factory Stock.copper() {
    return Stock(
      symbol: "hg%3Acmx",
      name: "Copper",
      asset: "commodities",
    );
  }

  factory Stock.naturalGas() {
    return Stock(
      symbol: "ng%3Anmx",
      name: "Natural Gas",
      asset: "commodities",
    );
  }

  @override
  int compareTo(Stock other) {
    return other.symbol.compareTo(symbol);
  }

  Stock copyWith({
    String? symbol,
    String? name,
    String? asset,
    double? lastSalePrice,
    double? netChange,
    double? percentChange,
  }) {
    return Stock(
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      asset: asset ?? this.asset,
      lastSalePrice: lastSalePrice ?? this.lastSalePrice,
      netChange: netChange ?? this.netChange,
      percentChange: percentChange ?? this.percentChange,
    );
  }
}
