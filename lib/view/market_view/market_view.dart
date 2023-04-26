import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investing/controller/market_controller.dart';
import 'package:investing/view/market_view/sector_view/sector_view.dart';
import 'package:investing/widget/title_widget.dart';

class MarketView extends StatefulWidget {
  const MarketView({super.key});

  @override
  State<MarketView> createState() => _MarketViewState();
}

class _MarketViewState extends State<MarketView> {
  final MarketController controller = MarketController.find();

  AppBar appBar() {
    return AppBar(
      title: const Text("Market Map"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Obx(
        () {
          final list = controller.marketDataList;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              return TitleWidget(
                title: Text(item.name),
                child: SectorView(sectorList: item.childeren),
              );
            },
          );
        },
      ),
    );
  }
}
