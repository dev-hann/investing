import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investing/const/color.dart';
import 'package:investing/controller/market_controller.dart';
import 'package:investing/model/market.dart';
import 'package:investing/widget/title_widget.dart';

// TODO: (Future Work) make view more compatable (like Finviz HeatMap)
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

  Color? stockColor(double value) {
    if (value == 0) {
      return null;
    }
    if (value <= -3) {
      return IVColor.lightRed;
    } else if (value < -2) {
      return IVColor.red;
    } else if (value < -0) {
      return IVColor.darkRed;
    } else if (value > 3) {
      return IVColor.lightGreen;
    } else if (value > 2) {
      return IVColor.green;
    } else if (value > 0) {
      return IVColor.darkGreen;
    }
    return null;
  }

  Widget sectorWidget({
    required MarketSector sector,
    required Map<String, double> percentData,
    required VoidCallback onTap,
  }) {
    final children = sector.childeren;
    return TitleWidget(
      gap: 4.0,
      title: Builder(
        builder: (context) {
          return Text(
            sector.name,
            style: Theme.of(context).textTheme.labelSmall,
          );
        },
      ),
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          height: 25,
          child: Row(
              children:
                  children.sublist(0, min(6, children.length)).map((item) {
            final percent = percentData[item.name] ?? 0.0;
            return Expanded(
              flex: pow(item.sumValue, 1 / 3).floor(),
              child: Row(
                children: [
                  const VerticalDivider(
                    color: IVColor.blueGrey,
                    width: 0,
                  ),
                  Expanded(
                    child: ColoredBox(
                      color: stockColor(percent) ?? Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AutoSizeText(
                            item.name,
                            maxLines: 1,
                            maxFontSize: 8,
                            minFontSize: 5,
                          ),
                          AutoSizeText(
                            "${percent.toStringAsFixed(2)}%",
                            maxLines: 1,
                            minFontSize: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList()),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Obx(
        () {
          final list = controller.marketDataList;
          final percentData = controller.marketPercentData;
          // return RotatedBox(
          //   quarterTurns: 1,
          //   child: SectorView(
          //       key: UniqueKey(),
          //       valueList: list[0].childeren.map((element) {
          //         print(element.name);
          //         return element.sumValue;
          //       }).toList()),
          // );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: list.map((data) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: TitleWidget(
                    gap: 0.0,
                    title: Center(
                      child: Text(
                        data.name,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: data.childeren
                          .map(
                            (sector) => sectorWidget(
                              sector: sector,
                              percentData: percentData,
                              onTap: () {
                                // TODO: (Future Work) make Sector Detail View
                                // Get.to(
                                //   SectorDetailView(
                                //     sectorName: marketData.name,
                                //     symbolList: symbolList,
                                //   ),
                                // );
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
