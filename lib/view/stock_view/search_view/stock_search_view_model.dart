import 'package:dividends_manager/controller/stock_controller.dart';
import 'package:dividends_manager/model/stock.dart';
import 'package:dividends_manager/view/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StockSearchViewModel extends ViewModel<StockController> {
  List<Stock> get stockList => controller.stockList;
  final List<Stock> searchedList = [];
  final TextEditingController queryCntroller = TextEditingController();
  final RxString queryValue = RxString("");
  late final Worker _queryWoker;

  @override
  Future init() {
    _queryWoker = debounce(queryValue, (query) {
      searchStock(query);
    }, time: const Duration(milliseconds: 500));
    return super.init();
  }

  @override
  Future dispose() {
    _queryWoker.dispose();
    return super.dispose();
  }

  void searchStock(String query) async {
    if (query.isEmpty) {
      return;
    }
    final list = await controller.searchStock(query);
    searchedList.clear();
    searchedList.addAll(list);
    controller.update();
  }

  Future toggleBookmark(Stock stock) {
    return controller.toggleBookmark(stock);
  }
}
