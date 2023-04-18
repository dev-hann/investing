import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:investing/model/stock.dart';

class IVChartWidget extends StatelessWidget {
  const IVChartWidget({
    super.key,
    required this.stock,
  });
  final Stock stock;

  @override
  Widget build(BuildContext context) {
    final priceChartList = stock.priceChartList;
    priceChartList.sort();
    final volumeChartList = stock.volumeChartList;
    volumeChartList.sort();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          return Column(
            children: [
              SizedBox(
                width: width,
                height: width / 2,
                child: LineChart(
                  LineChartData(
                    maxY: priceChartList.map((e) => e.value).reduce(max),
                    minY: priceChartList.map((e) => e.value).reduce(min),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: true),
                    lineBarsData: [
                      LineChartBarData(
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
                    ],
                  ),
                ),
              ),
              // volumeChartList.isEmpty
              //     ? const SizedBox()
              //     : SizedBox(
              //         width: width,
              //         height: width / 5,
              //         child: BarChart(
              //           BarChartData(
              //             barGroups: volumeChartList.map(
              //               (e) {
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
