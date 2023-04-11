import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:investing/model/chart.dart';

class IVChartWidget extends StatelessWidget {
  const IVChartWidget({
    super.key,
    required this.chatList,
  });
  final List<IVChart> chatList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LineChart(
        LineChartData(
          maxY: chatList.map((e) => e.y).reduce(max),
          minY: chatList.map((e) => e.y).reduce(min),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: true),
          lineBarsData: [
            LineChartBarData(
              dotData: FlDotData(
                show: false,
              ),
              spots: List.generate(
                chatList.length,
                (index) {
                  final item = chatList[index];
                  return FlSpot(item.x.toDouble(), item.y);
                },
              ).toList(),
            )
          ],
        ),
      ),
    );
  }
}
