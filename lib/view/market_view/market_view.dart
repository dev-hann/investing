import 'package:any_treemap/any_treemap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/const/color.dart';
import 'package:investing/controller/market_controller.dart';
import 'package:investing/model/market.dart';

// TODO: (Future Work) make view more compatable (like Finviz HeatMap)
class MarketView extends ConsumerWidget {
  const MarketView({super.key});

  AppBar appBar() {
    return AppBar(title: const Text('Market Map'));
  }

  Color stockColor(double value) {
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
    return IVColor.blueGrey;
  }

  TreemapNode<String> sectorNode({
    required String name,
    required List<MarketSector> children,
    required Map<String, double> percentData,
  }) {
    return TreemapNode<String>(
      key: 'sector:$name',
      label: name,
      children: [
        for (final stock in children)
          TreemapNode<String>(
            key: 'sector:$name:${stock.name}',
            label: stock.name,
            weight: stock.sumValue.toDouble(),
            color: stockColor(percentData[stock.name] ?? 0.0),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(marketControllerProvider);
    final list = state.marketDataList;
    final percentData = state.marketPercentData;
    return Scaffold(
      appBar: appBar(),
      body: Builder(
        builder: (context) {
          if (list.isEmpty) {
            return const SizedBox.shrink();
          }
          final tree = TreemapNormalizer.normalize(
            TreemapNode<String>(
              key: 'market',
              children: [
                for (final sector in list)
                  sectorNode(
                    name: sector.name,
                    children: sector.childeren,
                    percentData: percentData,
                  ),
              ],
            ),
          );
          return RotatedBox(
            quarterTurns: 1,
            child: TreemapChart<String>(
              tree: tree,
              tiles: TreemapTiles<String>(
                appearance: TreemapAppearanceResolver<String>(
                  colorScale: TreemapColorScale.exact(
                    const {},
                    fallback: IVColor.blueGrey,
                  ),
                ),
              ),
              labels: TreemapCanvasLabels<String>(),
              layout: const TreemapLayoutConfig(
                innerSpacing: 1,
                outerPadding: TreemapInsets.all(1),
              ),
            ),
          );
        },
      ),
    );
  }
}
