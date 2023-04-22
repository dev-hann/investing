import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:investing/const/color.dart';
import 'package:investing/model/date_time_range.dart';

class ChartButtonItem extends Equatable {
  const ChartButtonItem({
    required this.text,
  });
  final String text;

  @override
  List<Object?> get props => [text];
}

class IVChartButton extends StatelessWidget {
  const IVChartButton({
    super.key,
    this.selectedIndex = 0,
    this.activeColor = IVColor.grey,
    this.background = IVColor.blueGrey,
    required this.dateTimeList,
    required this.onTap,
  });
  final int selectedIndex;
  final List<IVDateTimeRange?> dateTimeList;
  final Color activeColor;
  final Color background;
  final Function(int index) onTap;

  List<ChartButtonItem> get itemList {
    // TODO: refactoring
    final list = <ChartButtonItem>[];
    for (final range in dateTimeList) {
      final inDays = range?.inDays ?? 1;
      list.add(ChartButtonItem(text: "${inDays}D"));
    }
    return list;
    // return const [
    //   ChartButtonItem(text: "1D"),
    //   ChartButtonItem(text: "1M"),
    //   ChartButtonItem(text: "3M"),
    //   ChartButtonItem(text: "1Y"),
    //   ChartButtonItem(text: "ALL"),
    // ];
  }

  Widget itemWidget(int index) {
    final item = itemList[index];
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        onTap(index);
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
              item.text,
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
        children: [
          for (int index = 0; index < itemList.length; ++index)
            Expanded(child: itemWidget(index)),
        ],
      ),
    );
  }
}
