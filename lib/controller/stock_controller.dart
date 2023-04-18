import 'dart:async';

import 'package:investing/controller/controller.dart';
import 'package:investing/data/db/data_base.dart';
import 'package:investing/model/market_status.dart';
import 'package:investing/model/stock.dart';
import 'package:investing/model/stock_detail.dart';
import 'package:investing/use_case/stock_use_case.dart';

class StockController extends Controller<StockUseCase> {
  StockController(super.useCase);

  final List<Stock> favoriteStockList = [];
  late MarketStatus marketStatus;
  Stream<IVDataBaseEvent<Stock>> get watchListStream =>
      useCase.watchListStream();

  @override
  Future onReady() async {
    _initFavoriteStockList();
    await _initMarketStatus();
    super.onReady();
  }

  Timer? _marketTimer;

  Future _initMarketStatus() async {
    marketStatus = await useCase.requestMarketStatus();
    // if (!marketStatus.isOpened) {
    //   final now = DateTime.now();
    //   final leftDuration = marketStatus.preMarketOpen.difference(now);
    //   _marketTimer = Timer.periodic(leftDuration, (timer) {
    //     _initMarketStatus();
    //     _marketTimer!.cancel();
    //   });
    // } else {
    //   _marketTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
    //     if (!marketStatus.isOpened) {
    //       _marketTimer!.cancel();
    //       return;
    //     }
    //   });
    // }
  }

  void _initFavoriteStockList() {
    watchListStream.listen((event) {
      refreshWatchList(event);
    });
    favoriteStockList.addAll(useCase.loadStockList());
    for (int index = 0; index < favoriteStockList.length; ++index) {
      final stock = favoriteStockList[index];
      useCase
          .requestStock(
        stock: stock,
        dateTimeRange: stock.dateTimeRangeList.first,
      )
          .then((value) async {
        favoriteStockList[index] = value;
        // TODO: update veiew by id
        updateView();
      });
    }
  }

  void refreshWatchList(IVDataBaseEvent<Stock> event) async {
    final stock = event.data;
    final index = favoriteStockList
        .indexWhere((element) => element.symbol == stock.symbol);
    final isDeleted = event.deleted;
    if (isDeleted) {
      favoriteStockList.removeAt(index);
    } else {
      final isNew = index == -1;
      if (isNew) {
        favoriteStockList.add(stock);
      } else {
        favoriteStockList[index] = stock;
      }
    }
    updateView();
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
    return favoriteStockList.contains(stock);
  }
}
