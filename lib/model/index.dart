import 'package:equatable/equatable.dart';
import 'package:investing/model/chart.dart';

enum IndexType {
  nasdaq,
  snp500,
  dow,
  treasury2Year,
  treasury20Year,
  oil,
  gold,
  copper,
  gas,
}

// extension IndexTypeExtension on IndexType {
//   String toSymbol() {
//     switch (this) {
//       case IndexType.nasdaq:
//         return "COMP";
//       case IndexType.snp500:
//         return "SPX";
//       case IndexType.dow:
//         return "INDU";
//       case IndexType.treasury2Year:
//         return "CMTN2Y";
//       case IndexType.treasury20Year:
//         return "CMTN20Y";
//       case IndexType.oil:
//         return "CL%3ANMX";
//       case IndexType.gold:
//         return "GC%3ACMX";
//       case IndexType.copper:
//         return "hg%3Acmx";
//       case IndexType.gas:
//         return "ng%3Anmx";
//       case IndexType.unknown:
//         return "";
//     }
//   }
// }

class Index extends Equatable {
  const Index({
    required this.symbol,
    required this.name,
    required this.lastSalePrice,
    required this.netChange,
    required this.percentageChange,
    required this.chartList,
  });
  final String symbol;
  final String name;
  final String lastSalePrice;
  final String netChange;
  final String percentageChange;
  final List<IVChart> chartList;
  IndexType get type {
    final s = symbol.toLowerCase();
    if (s.contains("nasdaq")) {
      return IndexType.nasdaq;
    } else if (s.contains("s&p")) {
      return IndexType.snp500;
    } else if (s.contains("dow")) {
      return IndexType.dow;
    } else if (s.contains("cmtn2y")) {
      return IndexType.treasury2Year;
    } else if (s.contains("cmtn20y")) {
      return IndexType.treasury20Year;
    } else if (s.contains("gc")) {
      return IndexType.gold;
    } else if (s.contains("hg")) {
      return IndexType.copper;
    } else if (s.contains("ng")) {
      return IndexType.gas;
    } else if (s.contains("cl")) {
      return IndexType.oil;
    } else {
      throw UnimplementedError("Request Symbol : $symbol Not Implemented");
    }
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

  factory Index.fromMap(dynamic map) {
    final data = Map<String, dynamic>.from(map["data"]);
    final chartList =
        List.from(data["chart"]).map((e) => IVChart.fromMap(e)).toList();
    chartList.sort();
    return Index(
      symbol: data["symbol"],
      name: data["company"],
      lastSalePrice: data["lastSalePrice"],
      netChange: data["netChange"],
      percentageChange: data["percentageChange"],
      chartList: chartList,
    );
  }

  // factory Index.treasury(dynamic map) {
  //   final data = Map<String, dynamic>.from(map)["data"];
  //   final primaryData = data["primaryData"];
  //   return Index(
  //     symbol: data["symbol"],
  //     name: data["companyName"],
  //     lastSalePrice: primaryData["lastSalePrice"],
  //     netChange: primaryData["netChange"],
  //     percentageChange: primaryData["percentageChange"],
  //     chartList: List.from(data["chart"]).map((e) => Chart.fromMap(e)).toList(),
  //     type: IndexType.treasury,
  //   );
  // }

  // factory Index.commodity(dynamic map) {
  //   final data = Map<String, dynamic>.from(map)["data"];
  //   final primaryData = data["primaryData"];
  //   return Index(
  //     symbol: data["symbol"],
  //     name: data["companyName"],
  //     lastSalePrice: primaryData["lastSalePrice"],
  //     netChange: primaryData["netChange"],
  //     percentageChange: primaryData["percentageChange"],
  //     type: IndexType.commodity,
  //   );
  // }
}
