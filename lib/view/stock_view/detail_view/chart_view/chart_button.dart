import 'package:flutter/material.dart';
import 'package:investing/const/color.dart';
import 'package:investing/model/chart.dart';

class IVChartButton extends StatelessWidget {
  const IVChartButton({
    super.key,
    this.activeColor = IVColor.grey,
    this.background = IVColor.blueGrey,
    required this.selected,
    required this.rangeTypeList,
    required this.onTap,
  });
  final ChartRangeType selected;
  final List<ChartRangeType> rangeTypeList;
  final Color activeColor;
  final Color background;
  final Function(ChartRangeType type) onTap;

  String text(ChartRangeType type) {
    switch (type) {
      case ChartRangeType.realTime:
        return "Live";
      case ChartRangeType.oneDay:
        return "1D";
      case ChartRangeType.oneMonth:
        return "1M";
      case ChartRangeType.threeMonth:
        return "3M";
      case ChartRangeType.oneYear:
        return "1Y";
      case ChartRangeType.all:
        return "All";
    }
  }

  Widget itemWidget(ChartRangeType type) {
    final isSelected = selected == type;
    return GestureDetector(
      onTap: () {
        onTap(type);
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isSelected ? activeColor : background,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              text(type),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: isSelected ? IVColor.blueGrey : null),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children:
            rangeTypeList.map((e) => Expanded(child: itemWidget(e))).toList(),
      ),
    );
  }
}
