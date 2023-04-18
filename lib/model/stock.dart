// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import 'package:investing/data/db/data_base_model_mixin.dart';
import 'package:investing/model/date_time_range.dart';
import 'package:investing/util/number_format.dart';

class Stock extends Equatable with DataBaseModelMixin, Comparable<Stock> {
  const Stock({
    required this.symbol,
    required this.name,
    required this.lastSalePrice,
    required this.previousSalePrice,
    required this.netChange,
    required this.percentageChange,
    required this.deltaIndicator,
    required this.asset,
  });
  final String symbol;
  final String name;
  final double lastSalePrice;
  final double previousSalePrice;
  final String netChange;
  final String percentageChange;
  final String deltaIndicator;
  final String asset;

  String get lastSalePriceText => IVNumberFormat.priceFormat(lastSalePrice);
  bool get isUp => deltaIndicator.toLowerCase() == "up";

  List<IVDateTimeRange?> get dateTimeRangeList {
    final list = <IVDateTimeRange?>[
      IVDateTimeRange.beforeDay(7),
      IVDateTimeRange.beforeMonth(1),
      IVDateTimeRange.beforeMonth(3),
      IVDateTimeRange.beforeYear(1),
      IVDateTimeRange.beforeYear(100),
    ];
    final assetValue = asset.toLowerCase();
    if (assetValue == "index" || assetValue == "stocks") {
      return [null, IVDateTimeRange.beforeDay(1), ...list];
    }
    return list;
  }

  bool get isEmpty {
    return deltaIndicator.isEmpty &&
        lastSalePriceText.isEmpty &&
        netChange.isEmpty &&
        percentageChange.isEmpty;
  }

  factory Stock.empty({
    required String symbol,
    required String name,
    required String asset,
  }) {
    return Stock(
      symbol: symbol,
      name: name,
      asset: asset,
      deltaIndicator: "",
      lastSalePrice: 0,
      previousSalePrice: 0,
      netChange: "",
      percentageChange: "",
    );
  }

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
    return Stock.empty(
      symbol: "SPX",
      name: "S&P 500",
      asset: "index",
    );
  }

  factory Stock.dow() {
    return Stock.empty(
      symbol: "INDU",
      name: "DOW",
      asset: "index",
    );
  }

  factory Stock.nasdaq() {
    return Stock.empty(
      symbol: "COMP",
      name: "Nasdaq",
      asset: "index",
    );
  }
  factory Stock.treasury2Y() {
    return Stock.empty(
      symbol: "CMTN2Y",
      name: "2 Years Treasury",
      asset: "fixedincome",
    );
  }
  factory Stock.treasury20Y() {
    return Stock.empty(
      symbol: "CMTN2Y",
      name: "20 Years Treasury",
      asset: "fixedincome",
    );
  }
  factory Stock.crudeOil() {
    return Stock.empty(
      symbol: "CL%3ANMX",
      name: "WTI Oil",
      asset: "commodities",
    );
  }

  factory Stock.gold() {
    return Stock.empty(
      symbol: "GC%3ACMX",
      name: "Gold",
      asset: "commodities",
    );
  }
  factory Stock.copper() {
    return Stock.empty(
      symbol: "hg%3Acmx",
      name: "Copper",
      asset: "commodities",
    );
  }

  factory Stock.naturalGas() {
    return Stock.empty(
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
    double? lastSalePrice,
    double? previousSalePrice,
    String? netChange,
    String? percentageChange,
    String? deltaIndicator,
    String? asset,
  }) {
    return Stock(
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      lastSalePrice: lastSalePrice ?? this.lastSalePrice,
      previousSalePrice: previousSalePrice ?? this.previousSalePrice,
      netChange: netChange ?? this.netChange,
      percentageChange: percentageChange ?? this.percentageChange,
      deltaIndicator: deltaIndicator ?? this.deltaIndicator,
      asset: asset ?? this.asset,
    );
  }
}
