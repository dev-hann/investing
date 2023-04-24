import 'package:equatable/equatable.dart';

import 'package:investing/model/date_time_range.dart';
import 'package:investing/model/stock/stock_chart.dart';
import 'package:investing/model/stock/stock_dividend.dart';
import 'package:investing/model/stock/stock_financial.dart';

class StockDetail extends Equatable {
  const StockDetail({
    this.dividend,
    this.financial,
    this.chartMap = const {},
    required this.dateTimeRange,
  });
  final StockDividend? dividend;
  final StockFinancial? financial;
  final Map<dynamic, StockChart> chartMap;
  final IVDateTimeRange dateTimeRange;

  StockChart? get chart {
    for (final item in chartMap.keys) {
      if (dateTimeRange.isEqual(item)) {
        return chartMap[item];
      }
    }
    return null;
  }

  bool containsChart(IVDateTimeRange dateTimeRange) {
    return chartMap.keys.contains(dateTimeRange);
  }

  @override
  List<Object?> get props => [
        dividend,
        financial,
        chartMap,
        dateTimeRange,
      ];

  StockDetail copyWith({
    StockDividend? dividend,
    StockFinancial? financial,
    Map<dynamic, StockChart>? chartMap,
    IVDateTimeRange? dateTimeRange,
  }) {
    return StockDetail(
      dividend: dividend ?? this.dividend,
      financial: financial ?? this.financial,
      chartMap: chartMap ?? this.chartMap,
      dateTimeRange: dateTimeRange ?? this.dateTimeRange,
    );
  }
}
