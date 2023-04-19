import 'dart:async';

import 'package:investing/controller/controller.dart';
import 'package:investing/data/db/data_base.dart';
import 'package:investing/model/market_status.dart';
import 'package:investing/model/stock.dart';
import 'package:investing/model/stock_detail.dart';
import 'package:investing/use_case/stock_use_case.dart';

class StockController extends Controller<StockUseCase> {
  StockController(super.useCase);

  late MarketStatus marketStatus;

  Stream<IVDataBaseEvent<Stock>> get favoriteStream => useCase.favoriteStream();

  Future refreshMarkStatus() async {
    marketStatus = await useCase.requestMarketStatus();
  }

  // Favorite
  final List<Stock> favoriteList = [];
  final List<StockDetail> favoriteDetailList = [];
  void refreshFavoriteList() {
    favoriteList.clear();
    favoriteList.addAll(useCase.loadStockList());
  }

  Future refreshFavoriteListQuote() async {
    for (int index = 0; index < favoriteList.length; ++index) {
      final stock = favoriteList[index];
      favoriteList[index] = await useCase.requestStock(
        stock: stock,
        dateTimeRange: stock.dateTimeRangeList.first,
      );
    }
  }

  Future refreshFavoriteDetail() async {}

  // Index
  final List<StockDetail> indexDetailList = [];
  Future refreshIndexList(List<Stock> indexList) async {
    indexDetailList.clear();
    for (int index = 0; index < indexList.length; ++index) {
      final stock = indexList[index];
      final res = await requestStockDetail(
        StockDetail.fromStock(stock),
      );
      indexDetailList.add(res);
    }
  }

  List<Stock> loadStockList() {
    return useCase.loadStockList();
  }

  Future updateFavoriteStock(Stock stock) {
    return useCase.updateStock(stock);
  }

  Future removeFavoriteStock(Stock stock) {
    return useCase.removeStock(stock.index);
  }

  Future<List<Stock>> searchStock(String query) async {
    return useCase.searchStock(query);
  }

  Future<StockDetail> requestStockDetail(StockDetail stockDetail) {
    return useCase.requestStockDetail(
      stockDetail: stockDetail,
      dateTimeRange: stockDetail.dateTimeRangeList.first,
    );
  }

  Future<List<Stock>> requestStockList(List<Stock> list) {
    return useCase.requestStockList(list);
  }

  bool contains(Stock stock) {
    return favoriteList.contains(stock);
  }
}
