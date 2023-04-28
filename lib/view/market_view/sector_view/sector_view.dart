import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:investing/const/color.dart';
import 'package:investing/model/market.dart';
import 'package:investing/widget/title_widget.dart';

class SectorView extends StatelessWidget {
  const SectorView({
    super.key,
    required this.sectorList,
    required this.percentData,
    required this.onTap,
  });
  final List<MarketSector> sectorList;
  final Map<String, double> percentData;
  final Function(List<String> symbolList) onTap;

  Widget sectorWidget(MarketSector sector) {
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
        onTap: () {
          onTap(children.map((e) => e.name).toList());
        },
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
                      color: IVColor.stockColor(percent) ?? Colors.transparent,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: sectorList.map((e) => sectorWidget(e)).toList(),
    );
  }
}
