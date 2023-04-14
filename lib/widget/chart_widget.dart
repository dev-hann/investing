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
    final chartList = stock.chartList;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          return SizedBox(
            width: width,
            height: width / 2,
            child: LineChart(
              LineChartData(
                maxY: chartList.map((e) => e.y).reduce(max),
                minY: chartList.map((e) => e.y).reduce(min),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    dotData: FlDotData(
                      show: false,
                    ),
                    spots: List.generate(
                      chartList.length,
                      (index) {
                        final item = chartList[index];
                        return FlSpot(item.x.toDouble(), item.y);
                      },
                    ).toList(),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
