import 'dart:async';

import 'package:investing/controller/stock_controller.dart';
import 'package:investing/model/index.dart';
import 'package:investing/model/ticker.dart';
import 'package:investing/view/view.dart';

class WatchListViewModel extends ViewModel<StockController> {
  List<Index> get indexList => controller.indexList;
  List<Ticker> get watchList => controller.watchList;

  Future removeFavoriteStock(Ticker stock) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return controller.removeFavoriteStock(stock.index);
  }
}
