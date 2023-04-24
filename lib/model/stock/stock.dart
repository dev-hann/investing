import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:investing/data/db/data_base_model_mixin.dart';
import 'package:investing/model/date_time_range.dart';
import 'package:investing/util/number_format.dart';

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

  List<IVDateTimeRange> get dateTimeList {
    switch (type) {
      case StockType.stock:
      case StockType.etf:
      case StockType.majorIndex:
        return [
          IVDateTimeRange.beforeDay(1),
          IVDateTimeRange.beforeMonth(1),
          IVDateTimeRange.beforeMonth(3),
          IVDateTimeRange.beforeYear(1),
          IVDateTimeRange.beforeYear(100),
        ];
      case StockType.fixedIncome:
      case StockType.commodity:
        return [
          IVDateTimeRange.beforeMonth(3),
          IVDateTimeRange.beforeYear(1),
          IVDateTimeRange.beforeYear(100),
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

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'symbol': symbol,
      'name': name,
      'asset': asset,
      'lastSalePrice': lastSalePrice,
      'netChange': netChange,
      'percentChange': percentChange,
    };
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

  static double _toDouble(String value) {
    return IVNumberFormat(value).toDouble();
  }

  factory Stock.fromMap(Map<String, dynamic> map) {
    final ticker = List.from(map["ticker"]);
    return Stock(
      symbol: ticker.first,
      name: ticker.last,
      asset: map["assetclass"],
      lastSalePrice: _toDouble(map["lastSale"]),
      netChange: _toDouble(map["change"]),
      percentChange: _toDouble(map["pctChange"]),
    );
  }
}
