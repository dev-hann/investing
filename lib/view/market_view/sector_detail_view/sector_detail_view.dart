import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/controller/market_controller.dart';
import 'package:investing/widget/loading_widget.dart';
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
    final data = await ref
        .read(marketControllerProvider.notifier)
        .requestMarketChartData(widget.symbolList);
    if (mounted) {
      setState(() {
        chartData = data;
      });
    }
  }

  AppBar appBar() {
    return AppBar(title: const Text('Sector Detail View'));
  }

  Widget item({required String symbol, required List<double> chartData}) {
    return Row(children: [Text(symbol)]);
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
                return const Center(child: IVLoadingWidget());
              }
              return Column(
                children: chartData.entries
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
