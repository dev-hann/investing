import 'dart:async';

import 'package:investing/controller/stock_controller.dart';
import 'package:investing/model/stock.dart';
import 'package:investing/view/view.dart';
import 'package:flutter/material.dart';

class StockSearchViewModel extends ViewModel<StockController> {
  List<Stock> get favoriteStockList => controller.favoriteList;
  final List<Stock> searchedList = [];
  final TextEditingController queryCntroller = TextEditingController();
  String get query => queryCntroller.text;

  @override
  Future init() {
    _initSearch();
    return super.init();
  }

  void _initSearch() {
    controller.favoriteStream.listen((event) {
      controller.refreshFavoriteList();
      updateView();
    });
    controller.refreshFavoriteList();
  }

  void searchStock(String query) async {
    if (query.isEmpty) {
      return;
    }
    await overlayLoading(() async {
      final list = await controller.searchStock(query);
      searchedList.clear();
      searchedList.addAll(list);
    });
    updateView();
  }

  Future toggleBookmark(Stock stock) async {
    if (controller.contains(stock)) {
      return controller.removeFavoriteStock(stock);
    }
    return controller.updateFavoriteStock(stock);
  }
}
