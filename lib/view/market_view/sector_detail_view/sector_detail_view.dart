import 'dart:async';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/const/color.dart';
import 'package:investing/controller/market_controller.dart';
import 'package:investing/widget/shimmer.dart';
import 'package:investing/widget/title_widget.dart';

class SectorDetailView extends ConsumerStatefulWidget {
  const SectorDetailView({
    super.key,
    required this.sectorName,
    required this.symbolList,
  });
  final String sectorName;
  final List<String> symbolList;

  @override
  ConsumerState<SectorDetailView> createState() => _SectorDetailViewState();
}

class _SectorDetailViewState extends ConsumerState<SectorDetailView> {
  Map<String, List<double>> chartData = {};

  @override
  void initState() {
    super.initState();
    unawaited(_requestChartData());
  }

  Future<void> _requestChartData() async {
    try {
      final data = await ref
          .read(marketControllerProvider.notifier)
          .requestMarketChartData(widget.symbolList);
      if (mounted) {
        setState(() {
          chartData = data;
        });
      }
    } catch (e) {
      debugPrint('SectorDetailView: chart data failed — $e');
      if (mounted) {
        setState(() {
          chartData = {};
        });
      }
    }
  }

  AppBar appBar() {
    return AppBar(title: Text(widget.sectorName));
  }

  Widget sparklineWidget(List<double> values) {
    if (values.length < 2) {
      return const SizedBox(width: 120.0, height: 40.0);
    }
    final spots = <FlSpot>[
      for (int index = 0; index < values.length; ++index)
        FlSpot(index.toDouble(), values[index]),
    ];
    final minY = values.reduce(min);
    final maxY = values.reduce(max);
    final isUp = values.last >= values.first;
    return SizedBox(
      width: 120.0,
      height: 40.0,
      child: LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          lineBarsData: [
            LineChartBarData(
              color: isUp ? IVColor.green : IVColor.red,
              dotData: const FlDotData(show: false),
              spots: spots,
            ),
          ],
        ),
      ),
    );
  }

  Widget percentText(List<double> values) {
    if (values.length < 2 || values.first == 0) {
      return const Text('');
    }
    final percent = (values.last / values.first - 1) * 100;
    final color = percent > 0
        ? IVColor.green
        : percent < 0
        ? IVColor.red
        : IVColor.darkWhite;
    return Text(
      '${percent > 0 ? '+' : ''}${percent.toStringAsFixed(2)}%',
      style: TextStyle(color: color),
    );
  }

  Widget item({required String symbol, required List<double> chartData}) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: ListTile(
        title: Text(symbol),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            percentText(chartData),
            const SizedBox(width: 8.0),
            sparklineWidget(chartData),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: TitleWidget(
          title: Text(widget.sectorName),
          child: Builder(
            builder: (context) {
              final data = chartData;
              if (data.isEmpty) {
                return Column(
                  children: [
                    for (int index = 0; index < 8; ++index)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: IVShimmer.listTile(),
                      ),
                  ],
                );
              }
              return Column(
                children: data.entries
                    .map(
                      (entry) =>
                          item(symbol: entry.key, chartData: entry.value),
                    )
                    .toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
