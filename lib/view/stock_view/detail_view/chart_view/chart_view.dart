import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/controller/stock_controller.dart';
import 'package:investing/model/chart.dart';
import 'package:investing/model/date_time_range.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/model/stock/stock_chart.dart';
import 'package:investing/view/stock_view/detail_view/chart_view/chart_button.dart';
import 'package:investing/widget/chart_widget.dart';

class ChartView extends ConsumerStatefulWidget {
  const ChartView({super.key, required this.stock});
  final Stock stock;

  @override
  ConsumerState<ChartView> createState() => _ChartViewState();
}

class _ChartViewState extends ConsumerState<ChartView> {
  final Map<ChartRangeType, StockChart> chartMap = {};
  late ChartRangeType chartRangeType = widget.stock.chartRangeTypeList.first;

  @override
  void initState() {
    super.initState();
    unawaited(requestStockChart(chartRangeType));
  }

  Future<void> requestStockChart(ChartRangeType type) async {
    if (!chartMap.containsKey(type)) {
      final data = await ref
          .read(stockControllerProvider.notifier)
          .requestStockChart(
            stock: widget.stock,
            dateTimeRange: IVDateTimeRange.fromRangeType(type),
          );
      chartMap[type] = data;
    }
    setState(() {
      chartRangeType = type;
    });
  }

  Widget chartButtonListView({required ChartRangeType selected}) {
    return IVChartButton(
      selected: selected,
      onTap: (type) {
        if (type == ChartRangeType.realTime) {
          // TODO:(Future Work) make Live Chart view
          return;
        }
        unawaited(requestStockChart(type));
      },
      rangeTypeList: ChartRangeType.values,
    );
  }

  Widget chartWidget(StockChart? chart) {
    return IVChartWidget(
      stockChart: chart,
      enableGesture: true,
      showBaseLine: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final chartValue = chartMap[chartRangeType];
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 56.0, bottom: 16.0),
          child: chartWidget(chartValue),
        ),
        chartButtonListView(selected: chartRangeType),
      ],
    );
  }
}
