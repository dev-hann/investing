import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:investing/const/color.dart';
import 'package:investing/model/market.dart';
import 'package:investing/widget/title_widget.dart';

class SectorView extends StatefulWidget {
  const SectorView({
    super.key,
    required this.sectorList,
    required this.percentData,
    required this.onTap,
  });
  final List<MarketSector> sectorList;
  final Map<String, double> percentData;
  final Function(List<String> symbolList) onTap;

  @override
  State<SectorView> createState() => _SectorViewState();
}

class _SectorViewState extends State<SectorView> {
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
          widget.onTap(children.map((e) => e.name).toList());
        },
        child: SizedBox(
          height: 25,
          child: Row(
              children:
                  children.sublist(0, min(6, children.length)).map((item) {
            final percent = widget.percentData[item.name] ?? 0.0;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.sectorList.map((e) => sectorWidget(e)).toList(),
    );
  }
}
