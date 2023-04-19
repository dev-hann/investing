import 'dart:async';

import 'package:investing/controller/stock_controller.dart';
import 'package:investing/model/market_status.dart';
import 'package:investing/model/stock.dart';
import 'package:investing/model/stock_detail.dart';
import 'package:investing/view/view.dart';

class WatchListViewModel extends ViewModel<StockController> {
  MarketStatus get marketStatus => controller.marketStatus;

  Timer? _marketTimer;

  @override
  Future init() async {
    _initFavoriteList();
    await _initMarketStatus();
    await _initIndexList();
    return super.init();
  }

  Future _initMarketStatus() async {
    await controller.refreshMarkStatus();
    if (marketStatus.isOpened) {
      updateView();
      return;
    }
    final now = DateTime.now();
    final leftDuration = now.difference(marketStatus.preMarketOpen);
    _marketTimer = Timer.periodic(leftDuration, (timer) {
      // Open Market!
      _initMarketStatus();
      _marketTimer?.cancel();
    });
  }

  Future refreshMarketStatus() async {
    controller.refreshMarkStatus();
    updateViewByID();
  }

  // IndexView
  final indexViewID = "IndexViewID";

  //TODO: make it edit by option button
  final List<Stock> _indexStockList = [
    Stock.nasdaq(),
    Stock.snp(),
    Stock.dow(),
    Stock.treasury2Y(),
    Stock.treasury20Y(),
    Stock.gold(),
    Stock.copper(),
    Stock.naturalGas(),
    Stock.crudeOil(),
  ];

  List<StockDetail> get indexDetailList => controller.indexDetailList;

  Future _initIndexList() async {
    await controller.refreshIndexList(_indexStockList);
  }

  Future refreshIndexList() async {
    await controller.refreshIndexList(_indexStockList);
    updateViewByID(indexViewID);
  }

  // FavoriteView
  final favoriteViewID = "FavoriteViewID";
  List<Stock> get favoriteList => controller.favoriteList;

  Future<void> _initFavoriteList() async {
    controller.favoriteStream.listen((event) {
      controller.refreshFavoriteList();
      updateViewByID(favoriteViewID);
    });
    controller.refreshFavoriteList();
    await controller.refreshFavoriteListQuote();
    // updateView();
  }

  void onTapRemoveStock(Stock stock) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return controller.removeFavoriteStock(stock);
  }
}
