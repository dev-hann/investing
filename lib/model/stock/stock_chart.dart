import 'package:equatable/equatable.dart';

import 'package:investing/model/chart.dart';
import 'package:investing/util/number_format.dart';

class StockChart extends Equatable {
  const StockChart({
    required this.lastSalePrice,
    required this.netChange,
    required this.percentageChange,
    required this.previousClose,
    required this.priceChartList,
    required this.volumeChartList,
  });
  final double lastSalePrice;
  final double netChange;
  final double percentageChange;
  final double previousClose;
  final List<IVChart> priceChartList;
  final List<IVChart> volumeChartList;

  @override
  List<Object?> get props => [
        lastSalePrice,
        netChange,
        percentageChange,
        previousClose,
        priceChartList,
        volumeChartList,
      ];

  static double _toDouble(String value) {
    return IVNumberFormat(value).toDouble();
  }

  factory StockChart.fromMap(Map<String, dynamic> map) {
    final priceChart = map["chart"];
    final volumeChart = map["volumeChart"] ?? [];
    return StockChart(
      lastSalePrice: _toDouble(map["lastSalePrice"]),
      netChange: _toDouble(map["netChange"]),
      percentageChange: _toDouble(map["percentageChange"]),
      previousClose: _toDouble(map["previousClose"]),
      priceChartList:
          List.from(priceChart).map((e) => IVChart.fromMap(e)).toList(),
      volumeChartList:
          List.from(volumeChart).map((e) => IVChart.fromMap(e)).toList(),
    );
  }
}
