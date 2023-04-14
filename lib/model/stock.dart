import 'package:equatable/equatable.dart';
import 'package:investing/data/db/data_base_model_mixin.dart';
import 'package:investing/model/chart.dart';
import 'package:investing/model/date_time_range.dart';

class Stock extends Equatable with DataBaseModelMixin, Comparable<Stock> {
  const Stock({
    required this.symbol,
    required this.name,
    required this.lastSalePrice,
    required this.netChange,
    required this.percentageChange,
    required this.deltaIndicator,
    required this.chartList,
    required this.asset,
    this.marketStatus = "Closed",
  });
  final String symbol;
  final String name;
  final String lastSalePrice;
  final String netChange;
  final String percentageChange;
  final String deltaIndicator;
  final List<IVChart> chartList;
  final String asset;
  final String marketStatus;

  List<IVDateTimeRange?> get dateTimeRangeList {
    final list = <IVDateTimeRange?>[
      IVDateTimeRange.beforeDay(7),
      IVDateTimeRange.beforeMonth(1),
      IVDateTimeRange.beforeMonth(3),
      IVDateTimeRange.beforeYear(1),
      IVDateTimeRange.beforeYear(100),
    ];
    final assetValue = asset.toLowerCase();
    if (assetValue == "index") {
      return [null, IVDateTimeRange.beforeDay(1), ...list];
    }
    return list;
  }

  bool get isEmpty {
    return deltaIndicator.isEmpty &&
        lastSalePrice.isEmpty &&
        netChange.isEmpty &&
        percentageChange.isEmpty &&
        chartList.isEmpty;
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
      lastSalePrice: "",
      netChange: "",
      percentageChange: "",
      chartList: const [],
    );
  }

  factory Stock.fromSearch(dynamic map) {
    final data = Map<String, dynamic>.from(map);
    return Stock.empty(
      name: List.from(data['name']).first as String,
      symbol: List.from(data['symbol']).first as String,
      asset: data["asset"] as String,
    );
  }

  factory Stock.fromDB(dynamic map) {
    final data = Map<String, dynamic>.from(map);
    return Stock.empty(
      name: data["name"],
      symbol: data["symbol"],
      asset: data["asset"],
    );
  }

  Stock fromStock(dynamic map) {
    final data = Map<String, dynamic>.from(map)["data"];
    final primaryData = data["primaryData"];
    return Stock(
      symbol: symbol,
      name: name,
      asset: asset,
      chartList: chartList,
      deltaIndicator: primaryData["deltaIndicator"],
      lastSalePrice: primaryData["lastSalePrice"],
      netChange: primaryData["netChange"],
      percentageChange: primaryData["percentageChange"],
      marketStatus: primaryData["marketStatus"],
    );
  }

  Stock fromStockWithChart(dynamic map) {
    final data = Map<String, dynamic>.from(map)["data"];
    final chartList =
        List.from(data["chart"]).map((e) => IVChart.fromMap(e)).toList();
    chartList.sort();
    return Stock(
      symbol: symbol,
      name: name,
      asset: asset,
      deltaIndicator: data["deltaIndicator"],
      lastSalePrice: data["lastSalePrice"],
      netChange: data["netChange"],
      percentageChange: data["percentageChange"],
      chartList: chartList,
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
}
