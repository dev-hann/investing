import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investing/controller/market_controller.dart';
import 'package:investing/widget/loading_widget.dart';
import 'package:investing/widget/title_widget.dart';

class SectorDetailView extends StatefulWidget {
  const SectorDetailView({
    super.key,
    required this.sectorName,
    required this.symbolList,
  });
  final String sectorName;
  final List<String> symbolList;

  @override
  State<SectorDetailView> createState() => _SectorDetailViewState();
}

class _SectorDetailViewState extends State<SectorDetailView> {
  final MarketController controller = MarketController.find();

  final RxMap<String, List<double>> chartData = RxMap();

  @override
  void initState() {
    super.initState();
    controller.requestMarketChartData(widget.symbolList).then(chartData);
  }

  AppBar appBar() {
    return AppBar(
      title: const Text("Sector Detail View"),
    );
  }

  Widget item({
    required String symbol,
    required List<double> chartData,
  }) {
    return Row(
      children: [
        Text(symbol),
      ],
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
          child: Obx(() {
            final data = chartData;
            if (data.isEmpty) {
              return const Center(
                child: IVLoadingWidget(),
              );
            }
            return Column(
              children: chartData.entries
                  .map(
                    (entry) => item(
                      symbol: entry.key,
                      chartData: entry.value,
                    ),
                  )
                  .toList(),
            );
          }),
        ),
      ),
    );
  }
}
