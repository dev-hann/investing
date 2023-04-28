import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:investing/const/color.dart';
import 'package:investing/model/chart.dart';
import 'package:investing/model/stock/stock_chart.dart';
import 'package:investing/util/date_time_format.dart';
import 'package:investing/util/number_format.dart';

class IVChartWidget extends StatelessWidget {
  IVChartWidget({
    super.key,
    required this.stockChart,
    bool showBaseLine = true,
    this.enableGesture = false,
  }) : showBaseLineNotifier = ValueNotifier(showBaseLine);
  final StockChart? stockChart;
  final bool enableGesture;
  final ValueNotifier<bool> showBaseLineNotifier;

  ExtraLinesData? previousPriceLineData({
    required bool show,
    required double previousClosePrice,
    required double maxLineValue,
    required double minLineValue,
  }) {
    if (!show) {
      return null;
    }

    return ExtraLinesData(
      horizontalLines: [
        HorizontalLine(
          y: maxLineValue,
          color: Colors.white,
          strokeWidth: 0.1,
          dashArray: [3, 3],
          label: HorizontalLineLabel(
            show: true,
            alignment: Alignment.topRight,
            padding: EdgeInsets.zero,
            style: const TextStyle(
              color: Colors.white,
            ),
            labelResolver: (value) {
              return value.y.toStringAsFixed(2);
            },
          ),
        ),
        HorizontalLine(
          y: minLineValue,
          color: Colors.white,
          strokeWidth: 0.1,
          dashArray: [3, 3],
          label: HorizontalLineLabel(
            show: true,
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.zero,
            style: const TextStyle(
              color: Colors.white,
            ),
            labelResolver: (value) {
              return value.y.toStringAsFixed(2);
            },
          ),
        ),
        HorizontalLine(
          y: previousClosePrice,
          color: IVColor.blue.withOpacity(0.4),
          dashArray: [3, 3],
          label: HorizontalLineLabel(
            show: true,
            alignment: Alignment.topRight,
            padding: EdgeInsets.zero,
            style: const TextStyle(
              color: Colors.white,
            ),
            labelResolver: (p0) {
              return p0.y.toString();
            },
          ),
        ),
      ],
    );
  }

  LineTouchData lineTouchData() {
    return LineTouchData(
      getTouchedSpotIndicator: (barData, spotIndexes) {
        return spotIndexes.map((e) {
          return TouchedSpotIndicatorData(
            FlLine(
              color: Colors.white,
              strokeWidth: 1,
            ),
            FlDotData(),
          );
        }).toList();
      },
      touchTooltipData: touchToolTipData(),
    );
  }

  LineTouchTooltipData touchToolTipData() {
    return LineTouchTooltipData(
      fitInsideHorizontally: true,
      showOnTopOfTheChartBoxArea: true,
      getTooltipItems: (touchedSpots) {
        return touchedSpots.map((e) {
          return LineTooltipItem(
            IVDateTimeFormat(
              DateTime.fromMillisecondsSinceEpoch(e.x.toInt()),
            ).dateTimeFormat("yyyy-MM-dd HH:mm")!,
            const TextStyle(
              color: Colors.white,
            ),
            children: [
              TextSpan(
                text: "\n${IVNumberFormat.priceFormat(e.y)}",
              ),
            ],
          );
        }).toList();
      },
    );
  }

  List<LineChartBarData> lineBarListData(List<IVChart> priceChartList) {
    return [
      LineChartBarData(
        // belowBarData: BarAreaData(
        //   show: true,
        //   spotsLine: BarAreaSpotsLine(),
        // ),
        // // color: stock.isUp ? IVColor.red : IVColor.blue,
        dotData: FlDotData(
          show: false,
        ),
        spots: List.generate(
          priceChartList.length,
          (index) {
            final item = priceChartList[index];
            return FlSpot(item.dateTime.toDouble(), item.value);
          },
        ).toList(),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Need Refactoring view.
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final chart = stockChart;
          final width = constraints.maxWidth;
          if (chart == null) {
            return SizedBox(
              width: width,
              height: width / 1.5,
            );
          }
          final priceChartList = chart.priceChartList;
          final volumeChartList = chart.volumeChartList;
          final previousClosePrice = chart.previousClose;
          double maxY = priceChartList.map((e) => e.value).reduce(max);
          double minY = priceChartList.map((e) => e.value).reduce(min);
          priceChartList.sort();
          volumeChartList.sort();
          if (enableGesture) {
            //TODO:  normalize chart.
            maxY = maxY + 0.01;
            minY = minY - (minY / 200);
          }
          return Column(
            children: [
              SizedBox(
                width: width,
                height: width / 1.5,
                child: ValueListenableBuilder<bool>(
                  valueListenable: showBaseLineNotifier,
                  builder: (context, showPreviousPrice, _) {
                    return Listener(
                      onPointerDown: (_) {
                        showBaseLineNotifier.value = false;
                      },
                      onPointerUp: (_) {
                        showBaseLineNotifier.value = true;
                      },
                      child: LineChart(
                        LineChartData(
                          maxY: maxY,
                          minY: minY,
                          titlesData: FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(show: false),
                          lineTouchData: lineTouchData(),
                          extraLinesData: previousPriceLineData(
                            show: showPreviousPrice,
                            previousClosePrice: previousClosePrice,
                            maxLineValue:
                                priceChartList.map((e) => e.value).reduce(max),
                            minLineValue:
                                priceChartList.map((e) => e.value).reduce(min),
                          ),
                          lineBarsData: lineBarListData(priceChartList),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // volumeChartList.isEmpty
              //     ? const SizedBox()
              //     : SizedBox(
              //         width: width,
              //         height: width / 5,
              //         child: BarChart(
              //           BarChartData(
              //             titlesData: FlTitlesData(show: false),
              //             barGroups: volumeChartList.map(
              //               (e) {
              //                 print(e.value);
              //                 return BarChartGroupData(
              //                   x: e.dateTime,
              //                   barRods: [
              //                     BarChartRodData(
              //                       toY: e.value,
              //                       width: 0.1,
              //                     ),
              //                   ],
              //                 );
              //               },
              //             ).toList(),
              //           ),
              //         ),
              //       )
            ],
          );
        },
      ),
    );
  }
}
