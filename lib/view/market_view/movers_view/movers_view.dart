import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/const/color.dart';
import 'package:investing/controller/market_controller.dart';
import 'package:investing/model/market.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/util/navigator.dart';
import 'package:investing/util/number_format.dart';
import 'package:investing/view/stock_view/detail_view/stock_detail_view.dart';
import 'package:investing/widget/shimmer.dart';
import 'package:investing/widget/stock_card.dart';
import 'package:investing/widget/stock_price_builder.dart';

class MoversView extends ConsumerStatefulWidget {
  const MoversView({super.key, this.initialCategory});

  final MarketMoverCategory? initialCategory;

  @override
  ConsumerState<MoversView> createState() => _MoversViewState();
}

class _MoversViewState extends ConsumerState<MoversView>
    with TickerProviderStateMixin {
  static const _categories = MarketMoverCategory.values;

  late final TabController tabController = TabController(
    length: _categories.length,
    vsync: this,
    initialIndex:
        widget.initialCategory?.index ?? MarketMoverCategory.advancers.index,
  );

  /// Per-category cache: `null` = not loaded yet, empty = no data.
  final Map<MarketMoverCategory, List<Stock>?> moverList = {};

  @override
  void initState() {
    super.initState();
    tabController.addListener(_onTabChanged);
    unawaited(_requestMovers(_categories[tabController.index]));
  }

  @override
  void dispose() {
    tabController.removeListener(_onTabChanged);
    tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (tabController.indexIsChanging) {
      return;
    }
    final category = _categories[tabController.index];
    if (moverList[category] == null) {
      unawaited(_requestMovers(category));
    }
  }

  Future<void> _requestMovers(MarketMoverCategory category) async {
    try {
      final list = await ref
          .read(marketControllerProvider.notifier)
          .requestMovers(category);
      if (mounted) {
        setState(() {
          moverList[category] = list;
        });
      }
    } catch (e) {
      debugPrint('MoversView: request failed ($category) — $e');
      if (mounted) {
        setState(() {
          moverList[category] = [];
        });
      }
    }
  }

  AppBar appBar() {
    return AppBar(
      title: const Text('Movers'),
      bottom: TabBar(
        tabs: [
          for (final category in _categories)
            Tab(
              text: switch (category) {
                MarketMoverCategory.advancers => 'Advancers',
                MarketMoverCategory.decliners => 'Decliners',
                MarketMoverCategory.actives => 'Most Active',
              },
            ),
        ],
      ),
    );
  }

  Widget priceWidget(Stock stock) {
    return IVStockPriceBuilder(
      stock: stock,
      builder: (indicator, percentageChange, netChage, lastPrice) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              IVNumberFormat.priceFormat(lastPrice),
              style: const TextStyle(color: IVColor.white),
            ),
            Text('$indicator$percentageChange%'),
          ],
        );
      },
    );
  }

  Widget listWidget(MarketMoverCategory category) {
    final list = moverList[category];
    return Builder(
      builder: (context) {
        if (list == null) {
          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            separatorBuilder: (_, _) => const SizedBox(height: 8.0),
            itemCount: 15,
            itemBuilder: (_, _) => IVShimmer.listTile(),
          );
        }
        if (list.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('No Result'),
                TextButton(
                  onPressed: () {
                    setState(() {
                      moverList[category] = null;
                    });
                    unawaited(_requestMovers(category));
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16.0),
          physics: const BouncingScrollPhysics(),
          separatorBuilder: (_, _) => const SizedBox(height: 8.0),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final stock = list[index];
            return Card(
              clipBehavior: Clip.hardEdge,
              child: StockCard(
                stock: stock,
                onTap: () {
                  unawaited(pushView(context, StockDetailView(stock: stock)));
                },
                trailing: priceWidget(stock),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: TabBarView(
        children: [for (final category in _categories) listWidget(category)],
      ),
    );
  }
}
