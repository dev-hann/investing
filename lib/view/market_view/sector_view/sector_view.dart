import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investing/model/market.dart';
import 'package:investing/widget/title_widget.dart';

class SectorView extends StatelessWidget {
  const SectorView({
    super.key,
    required this.sectorList,
  });
  final List<MarketSector> sectorList;

  Widget sectorWidget(MarketSector sector) {
    return TitleWidget(
      title: Builder(
        builder: (context) {
          return Text(
            sector.name,
            style: Theme.of(context).textTheme.titleSmall,
          );
        },
      ),
      child: const Text("@@"),
    );
  }

  Widget box({
    required double maxWidth,
    required double maxHeight,
    required int ratio,
  }) {
    if (maxWidth > maxHeight) {
      return SizedBox(
        height: maxHeight,
        child: Row(
          children: [
            Expanded(
              flex: ratio,
              child: const ColoredBox(
                color: Colors.red,
                child: SizedBox.expand(),
              ),
            ),
            Expanded(
              flex: 100 - ratio,
              child: const ColoredBox(
                color: Colors.blue,
                child: SizedBox.expand(),
              ),
            ),
          ],
        ),
      );
    }
    return SizedBox(
      width: maxWidth,
      child: Column(
        children: [
          Expanded(
            flex: ratio,
            child: const ColoredBox(
              color: Colors.red,
              child: SizedBox.expand(),
            ),
          ),
          Expanded(
            flex: 100 - ratio,
            child: const ColoredBox(
              color: Colors.blue,
              child: SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = Get.width;
    final h = w / 2;
    return Card(
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: w,
        height: h,
        child: box(
          maxWidth: w,
          maxHeight: h,
          ratio: 20,
        ),
      ),
    );
  }
}
