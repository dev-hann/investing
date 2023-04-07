import 'dart:async';

import 'package:investing/controller/stock_controller.dart';
import 'package:investing/model/stock.dart';
import 'package:investing/view/view.dart';

class WatchListViewModel extends ViewModel<StockController> {
  List<Stock> get indexList => controller.indexList;
  List<Stock> get watchList => controller.watchList;

  Future removeWatchList(Stock stock) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return controller.removeStock(stock.index);
  }
}
