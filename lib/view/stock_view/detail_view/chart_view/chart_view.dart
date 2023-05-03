import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investing/controller/stock_controller.dart';
import 'package:investing/model/chart.dart';
import 'package:investing/model/date_time_range.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/model/stock/stock_chart.dart';
import 'package:investing/view/stock_view/detail_view/chart_view/chart_button.dart';
import 'package:investing/widget/chart_widget.dart';

class ChartView extends StatefulWidget {
  const ChartView({
    super.key,
    required this.stock,
  });
  final Stock stock;

  @override
  State<ChartView> createState() => _ChartViewState();
}

class _ChartViewState extends State<ChartView> {
  final StockController controller = StockController.find();
  final RxMap<ChartRangeType, StockChart> chartMap = RxMap();
  late final Rx<ChartRangeType> chartRangeType =
      Rx(widget.stock.chartRangeTypeList.first);

  @override
  void initState() {
    super.initState();
    requestStockChart(chartRangeType.value);
  }

  Future requestStockChart(ChartRangeType type) async {
    if (!chartMap.containsKey(type)) {
      final data = await controller.requestStockChart(
        stock: widget.stock,
        dateTimeRange: IVDateTimeRange.fromRangeType(type),
      );
      chartMap[type] = data;
    }
    chartRangeType(type);
  }

  Widget chartButtonListView({
    required ChartRangeType selected,
  }) {
    return IVChartButton(
      selected: selected,
      onTap: (type) {
        if (type == ChartRangeType.realTime) {
          // TODO:(Future Work) make Live Chart view
          return;
        }
        requestStockChart(type);
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
    return Obx(() {
      final chartRangeTypeValue = chartRangeType.value;
      final chartValue = chartMap[chartRangeTypeValue];
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 56.0,
              bottom: 16.0,
            ),
            child: chartWidget(chartValue),
          ),
          chartButtonListView(
            selected: chartRangeTypeValue,
          ),
        ],
      );
    });
  }
}
