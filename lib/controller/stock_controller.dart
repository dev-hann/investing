import 'dart:async';

import 'package:get/get.dart';
import 'package:investing/controller/controller.dart';
import 'package:investing/data/db/data_base.dart';
import 'package:investing/model/date_time_range.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/model/stock/stock_chart.dart';
import 'package:investing/model/stock/stock_dividend.dart';
import 'package:investing/model/stock/stock_financial.dart';
import 'package:investing/model/market_status.dart';
import 'package:investing/use_case/stock_use_case.dart';

class StockController extends Controller<StockUseCase> {
  StockController(super.useCase);

  @override
  void onReady() async {
    super.onReady();
    await useCase.init();
    _initMarketStatus();
    _initIndexList();
    _initFavoriteList();
  }

  static StockController find() => Get.find<StockController>();

  Stream<IVDataBaseEvent<Stock>> get favoriteStream => useCase.favoriteStream();

  // Favorite
  final RxList<Stock> favoriteList = <Stock>[].obs;
  Future<void> _initFavoriteList() async {
    favoriteStream.listen((event) async {
      refreshFavoriteList();
    });
    refreshFavoriteList();
  }

  void refreshFavoriteList() async {
    final list = await useCase.requestStockList(
      useCase.loadStockList(),
    );
    list.sort();
    favoriteList(list);
  }

  Future updateFavoriteList(List<Stock> list) async {
    favoriteList(list);
    for (final stock in list) {
      updateFavoriteStock(stock);
    }
  }

  Future updateFavoriteStock(Stock stock) async {
    await useCase.updateStock(stock);
  }

  Future removeFavoriteStock(Stock stock) {
    return useCase.removeStock(stock.index);
  }

  // Index
  //TODO: make it edit by option button
  final RxList<Stock> indexList = [
    Stock.nasdaq100(),
    Stock.nasdaq(),
    Stock.snp(),
    Stock.dow(),
    Stock.treasury2Y(),
    Stock.treasury20Y(),
    Stock.gold(),
    Stock.copper(),
    Stock.naturalGas(),
    Stock.crudeOil(),
  ].obs;
  Future _initIndexList() async {
    await refreshIndexList();
  }

  final RxList<StockChart> indexChartList = RxList(<StockChart>[]);
  Future refreshIndexList() async {
    final res = await useCase.requestStockList(indexList);
    indexList(res);
    final list = <StockChart>[];
    for (int index = 0; index < indexList.length; ++index) {
      final stock = indexList[index];
      final res = await useCase.requestStockChart(
        symbol: stock.symbol,
        asset: stock.asset,
        dateTimeRange: stock.dateTimeList.first,
      );
      list.add(res);
    }
    indexChartList(list);
  }

  // MarketStatus
  final Rx<MarketStatus?> marketStatus = Rx(null);

  // late Timer? _marketTimer;
  Future _initMarketStatus() async {
    final status = await useCase.requestMarketStatus();
    marketStatus(status);
    // if (marketStatus!.isOpened) {
    //   return;
    // }
    // final now = DateTime.now();
    // final leftDuration = now.difference(marketStatus.preMarketOpen);
    // _marketTimer = Timer.periodic(leftDuration, (timer) {
    //   // Open Market!
    //   _initMarketStatus();
    //   _marketTimer?.cancel();
    // });
  }

  Future refreshMarkStatus() async {
    marketStatus(await useCase.requestMarketStatus());
  }

  // Search
  Future<List<Stock>> searchStock(String query) async {
    return showOverlay(
      () async {
        return await useCase.searchStock(query);
      },
    );
  }

  // Stock Detail

  Future<StockDividend?> requestStockDividend(Stock stock) async {
    try {
      return useCase.requestStockDividend(
        symbol: stock.symbol,
        asset: stock.asset,
      );
    } catch (e) {
      return null;
    }
  }

  Future<StockFinancial?> requestStockFinancial({
    required Stock stock,
    required FinancialType type,
  }) {
    return useCase.requestStockFinancial(
      symbol: stock.symbol,
      type: type,
    );
  }

  Future<StockChart> requestStockChart({
    required Stock stock,
    required IVDateTimeRange dateTimeRange,
  }) {
    return useCase.requestStockChart(
      symbol: stock.symbol,
      asset: stock.asset,
      dateTimeRange: dateTimeRange,
    );
  }
}
