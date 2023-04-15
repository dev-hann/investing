import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:investing/const/color.dart';

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
    required this.itemList,
  });
  final int selectedIndex;
  final List<ChartButtonItem> itemList;
  final Color activeColor;
  final Color background;

  Widget itemWidget(int index) {
    final item = itemList[index];
    final isSelected = selectedIndex == index;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isSelected ? activeColor : background,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            item.text,
            style: TextStyle(color: isSelected ? IVColor.blueGrey : null),
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
