import 'dart:async';

import 'package:investing/controller/controller.dart';
import 'package:get/get.dart';
import 'package:investing/data/db/data_base.dart';
import 'package:investing/model/market_status.dart';
import 'package:investing/model/stock.dart';
import 'package:investing/use_case/stock_use_case.dart';

class StockController extends Controller<StockUseCase> {
  StockController(super.useCase);

  static StockController find() => Get.find<StockController>();
  final List<Stock> favoriteStockList = [];
  late MarketStatus marketStatus;
  Stream<IVDataBaseEvent> get watchListStream => useCase.watchListStream();

  @override
  Future onReady() async {
    _initFavoriteStockList();
    await _initMarketStatus();
    super.onReady();
  }

  Timer? _marketTimer;

  Future _initMarketStatus() async {
    marketStatus = await useCase.requestMarketStatus();
    if (!marketStatus.isOpened) {
      final now = DateTime.now();
      final leftDuration = marketStatus.preMarketOpen.difference(now);
      _marketTimer = Timer.periodic(leftDuration, (timer) {
        _initMarketStatus();
        _marketTimer!.cancel();
      });
    } else {
      _marketTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
        if (!marketStatus.isOpened) {
          _marketTimer!.cancel();
          return;
        }
      });
    }
  }

  void _initFavoriteStockList() {
    watchListStream.listen((event) {
      refreshWatchList(event);
    });
    favoriteStockList.addAll(useCase.loadStockList());
    for (int index = 0; index < favoriteStockList.length; ++index) {
      final stock = favoriteStockList[index];
      useCase
          .requestStockWithChart(
        stock: stock,
        dateTimeRange: stock.dateTimeRangeList.first,
      )
          .then((value) async {
        favoriteStockList[index] = value;
        // TODO: update veiew by id
        update();
      });
    }
  }

  void refreshWatchList(IVDataBaseEvent event) async {
    final index =
        favoriteStockList.indexWhere((element) => element.symbol == event.key);
    final isDeleted = event.deleted;
    if (isDeleted) {
      favoriteStockList.removeAt(index);
    } else {
      final data = event.value;
      final stock = Stock.empty(
        name: data["name"],
        symbol: data["symbol"],
        asset: data["asset"],
      );
      // final stock = Stock.fromDB(event.value);
      final isNew = index == -1;
      if (isNew) {
        favoriteStockList.add(stock);
      } else {
        final res = await useCase.requestStockWithChart(
          stock: stock,
          dateTimeRange: stock.dateTimeRangeList.first,
        );
        favoriteStockList[index] = res;
      }
    }
    update();
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

  Future<Stock> requestStockWithChart(Stock stock) {
    return useCase.requestStockWithChart(
      stock: stock,
      dateTimeRange: stock.dateTimeRangeList.first,
    );
  }

  Future<List<Stock>> requestStockList(List<Stock> list) {
    return useCase.requestStockList(list);
  }

  bool contains(Stock stock) {
    return favoriteStockList.contains(stock);
  }
}
