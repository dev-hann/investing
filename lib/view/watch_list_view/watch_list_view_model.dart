import 'dart:async';

import 'package:investing/controller/stock_controller.dart';
import 'package:investing/model/stock.dart';
import 'package:investing/view/view.dart';

class WatchListViewModel extends ViewModel<StockController> {
  final List<Stock> indexList = [
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
  List<Stock> get watchList => controller.favoriteStockList;

  @override
  Future init() async {
    await refreshIndexList();
    return super.init();
  }

  Future refreshIndexList() async {
    final list = [...indexList];
    for (int index = 0; index < list.length; ++index) {
      final item = list[index];
      final res = await controller.requestStockWithChart(item);
      list[index] = res;
    }
    indexList.clear();
    indexList.addAll(list);
    updateView();
  }

  Future removeFavoriteStock(Stock stock) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return controller.removeFavoriteStock(stock);
  }
}
