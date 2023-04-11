import 'package:investing/model/chart.dart';
import 'package:investing/model/stock.dart';

class Index extends Stock {
  const Index({
    required super.symbol,
    required super.name,
    required super.lastSalePrice,
    required super.netChange,
    required super.percentageChange,
    required super.chartList,
    required super.type,
  });

  factory Index.empty({
    required String symbol,
    required String name,
    required StockType type,
  }) {
    return Index(
      symbol: symbol,
      name: name,
      type: type,
      lastSalePrice: "",
      netChange: "",
      percentageChange: "",
      chartList: const [],
    );
  }

  factory Index.snp() {
    return Index.empty(
      symbol: "SPX",
      name: "S&P 500",
      type: StockType.majorIndex,
    );
  }

  factory Index.dow() {
    return Index.empty(
      symbol: "INDU",
      name: "DOW",
      type: StockType.majorIndex,
    );
  }

  factory Index.nasdaq() {
    return Index.empty(
      symbol: "COMP",
      name: "Nasdaq",
      type: StockType.majorIndex,
    );
  }
  factory Index.treasury2Y() {
    return Index.empty(
      symbol: "CMTN2Y",
      name: "2 Years Treasury",
      type: StockType.finxedIncome,
    );
  }
  factory Index.treasury20Y() {
    return Index.empty(
      symbol: "CMTN2Y",
      name: "20 Years Treasury",
      type: StockType.finxedIncome,
    );
  }
  factory Index.crudeOil() {
    return Index.empty(
      symbol: "CL%3ANMX",
      name: "WTI Oil",
      type: StockType.commodity,
    );
  }

  factory Index.gold() {
    return Index.empty(
      symbol: "GC%3ACMX",
      name: "Gold",
      type: StockType.commodity,
    );
  }
  factory Index.copper() {
    return Index.empty(
      symbol: "hg%3Acmx",
      name: "Copper",
      type: StockType.commodity,
    );
  }

  factory Index.naturalGas() {
    return Index.empty(
      symbol: "ng%3Anmx",
      name: "Natural Gas",
      type: StockType.commodity,
    );
  }

  Index dto(dynamic map) {
    final data = Map<String, dynamic>.from(map)["data"];
    final chartList =
        List.from(data["chart"]).map((e) => IVChart.fromMap(e)).toList();
    chartList.sort();
    return Index(
      symbol: symbol,
      name: name,
      type: type,
      lastSalePrice: data["lastSalePrice"],
      netChange: data["netChange"],
      percentageChange: data["percentageChange"],
      chartList: chartList,
    );
  }

  @override
  List<Object?> get props => [
        symbol,
        name,
        lastSalePrice,
        netChange,
        percentageChange,
        chartList,
      ];

  @Deprecated("will be deprecated")
  factory Index.fromMap(dynamic map) {
    final data = Map<String, dynamic>.from(map["data"]);
    final chartList =
        List.from(data["chart"]).map((e) => IVChart.fromMap(e)).toList();
    chartList.sort();
    return Index(
      symbol: data["symbol"],
      type: StockType.etf,
      name: data["company"],
      lastSalePrice: data["lastSalePrice"],
      netChange: data["netChange"],
      percentageChange: data["percentageChange"],
      chartList: chartList,
    );
  }
}
