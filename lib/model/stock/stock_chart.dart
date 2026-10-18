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
    final priceChart = map['chart'] as List<dynamic>;
    final volumeChart = (map['volumeChart'] ?? <dynamic>[]) as List<dynamic>;
    return StockChart(
      lastSalePrice: _toDouble(map['lastSalePrice'] as String),
      netChange: _toDouble(map['netChange'] as String),
      percentageChange: _toDouble(map['percentageChange'] as String),
      previousClose: _toDouble(map['previousClose'] as String),
      priceChartList: priceChart
          .map((e) => IVChart.fromMap(e as Map<String, dynamic>))
          .toList(),
      volumeChartList: volumeChart
          .map((e) => IVChart.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
