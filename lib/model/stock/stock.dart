import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:investing/model/chart.dart';

enum StockType {
  stock,
  etf,
  majorIndex,
  fixedIncome,
  commodity,
}

enum IndicatorStatus {
  up,
  down,
  same,
}

class Stock extends Equatable with Comparable<Stock> {
  Stock({
    required this.symbol,
    required this.name,
    required this.asset,
    this.lastSalePrice = 0.0,
    this.netChange = 0.0,
    this.percentChange = 0.0,
    int? order,
  }) : order = order ?? -DateTime.now().millisecondsSinceEpoch;
  final int order;
  final String symbol;
  final String name;
  final String asset;
  final double lastSalePrice;
  final double netChange;
  final double percentChange;

  StockType get type {
    final assetText = asset.toLowerCase();
    if (assetText == "etf") {
      return StockType.etf;
    } else if (assetText == "stocks") {
      return StockType.stock;
    } else if (assetText == "index") {
      return StockType.majorIndex;
    } else if (assetText == "fixedincome") {
      return StockType.fixedIncome;
    } else if (assetText == "commodities") {
      return StockType.commodity;
    }
    throw FlutterError("Unknown Stock Type $assetText");
  }

  List<ChartRangeType> get chartRangeTypeList {
    switch (type) {
      case StockType.stock:
      case StockType.etf:
      case StockType.majorIndex:
        return ChartRangeType.values.toList();
      case StockType.fixedIncome:
      case StockType.commodity:
        return [
          ChartRangeType.oneMonth,
          ChartRangeType.oneYear,
          ChartRangeType.all,
        ];
    }
  }

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

  bool isEquals(Stock other) {
    return symbol == other.symbol;
  }

  @override
  List<Object?> get props => [
        symbol,
        name,
        asset,
        lastSalePrice,
        netChange,
        percentChange,
        order,
      ];

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
  factory Stock.nasdaq100() {
    return Stock(
      symbol: "NDX",
      name: "Nasdaq-100",
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
      symbol: "CMTN2Y",
      name: "2 Years Treasury",
      asset: "fixedincome",
    );
  }
  factory Stock.treasury20Y() {
    return Stock(
      symbol: "CMTN20Y",
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
    // return other.order.compareTo(order);
    return order.compareTo(other.order);
  }

  Stock copyWith({
    String? symbol,
    String? name,
    String? asset,
    double? lastSalePrice,
    double? netChange,
    double? percentChange,
    int? order,
  }) {
    return Stock(
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      asset: asset ?? this.asset,
      order: order ?? this.order,
      lastSalePrice: lastSalePrice ?? this.lastSalePrice,
      netChange: netChange ?? this.netChange,
      percentChange: percentChange ?? this.percentChange,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'order': order,
      'symbol': symbol,
      'name': name,
      'asset': asset,
      'lastSalePrice': lastSalePrice,
      'netChange': netChange,
      'percentChange': percentChange,
    };
  }

  factory Stock.fromMap(dynamic data) {
    final map = Map<String, dynamic>.from(data);
    return Stock(
      order: map['order'] as int,
      symbol: map['symbol'] as String,
      name: map['name'] as String,
      asset: map['asset'] as String,
      lastSalePrice: map['lastSalePrice'] as double,
      netChange: map['netChange'] as double,
      percentChange: map['percentChange'] as double,
    );
  }
}
