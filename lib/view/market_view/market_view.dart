import 'dart:async';

import 'package:any_treemap/any_treemap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/const/color.dart';
import 'package:investing/controller/market_controller.dart';
import 'package:investing/model/market.dart';
import 'package:investing/util/navigator.dart';
import 'package:investing/view/market_view/movers_view/movers_view.dart';
import 'package:investing/view/market_view/screener_view/screener_view.dart';
import 'package:investing/view/market_view/sector_detail_view/sector_detail_view.dart';
import 'package:investing/widget/shimmer.dart';
import 'package:investing/widget/title_widget.dart';

class MarketView extends ConsumerWidget {
  const MarketView({super.key});

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: const Text('Market'),
      actions: [
        IconButton(
          onPressed: () {
            unawaited(pushView(context, const ScreenerView()));
          },
          icon: const Icon(Icons.filter_list),
        ),
      ],
    );
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

  Widget heatmapWidget({
    required List<MarketData> list,
    required Map<String, double> percentData,
  }) {
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
    return Card(
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        height: 360.0,
        child: RotatedBox(
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
        ),
      ),
    );
  }

  Widget sectorPercentText(double percent) {
    final color = percent > 0
        ? IVColor.green
        : percent < 0
        ? IVColor.red
        : IVColor.darkWhite;
    return Text(
      '${percent > 0 ? '+' : ''}${percent.toStringAsFixed(2)}%',
      style: TextStyle(color: color),
    );
  }

  Widget sectorListWidget({
    required List<MarketData> list,
    required Map<String, double> percentData,
  }) {
    return Column(
      children: [
        for (final market in list)
          for (final sector in market.childeren)
            Card(
              clipBehavior: Clip.hardEdge,
              child: Builder(
                builder: (context) {
                  final items = sector.childeren;
                  final percents = items
                      .map((item) => percentData[item.name])
                      .whereType<double>()
                      .toList();
                  final avg = percents.isEmpty
                      ? 0.0
                      : percents.fold(0.0, (a, b) => a + b) / percents.length;
                  return ListTile(
                    title: Text(sector.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        sectorPercentText(avg),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    onTap: () {
                      unawaited(
                        pushView(
                          context,
                          SectorDetailView(
                            sectorName: sector.name,
                            symbolList: [for (final item in items) item.name],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
      ],
    );
  }

  Widget moversWidget(BuildContext context) {
    Widget categoryButton({
      required String label,
      required MarketMoverCategory category,
    }) {
      return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: ActionChip(
          label: Text(label),
          onPressed: () {
            unawaited(pushView(context, MoversView(initialCategory: category)));
          },
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          categoryButton(
            label: 'Advancers',
            category: MarketMoverCategory.advancers,
          ),
          categoryButton(
            label: 'Decliners',
            category: MarketMoverCategory.decliners,
          ),
          categoryButton(
            label: 'Most Active',
            category: MarketMoverCategory.actives,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(marketControllerProvider);
    final list = state.marketDataList;
    final percentData = state.marketPercentData;
    return Scaffold(
      appBar: appBar(context),
      body: Builder(
        builder: (context) {
          if (list.isEmpty) {
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const IVShimmer(height: 360.0),
                const SizedBox(height: 8.0),
                for (int index = 0; index < 6; ++index)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: IVShimmer.listTile(),
                  ),
              ],
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16.0),
            physics: const BouncingScrollPhysics(),
            children: [
              TitleWidget(
                title: const Text('Heatmap'),
                child: heatmapWidget(list: list, percentData: percentData),
              ),
              const SizedBox(height: 16.0),
              TitleWidget(
                title: const Text('Sectors'),
                child: sectorListWidget(list: list, percentData: percentData),
              ),
              const SizedBox(height: 16.0),
              TitleWidget(
                title: const Text('Movers'),
                child: moversWidget(context),
              ),
            ],
          );
        },
      ),
    );
  }
}
