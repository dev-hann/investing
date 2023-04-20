import 'dart:async';

import 'package:get/get.dart';
import 'package:investing/controller/controller.dart';
import 'package:investing/data/db/data_base.dart';
import 'package:investing/model/stock_dividend.dart';
import 'package:investing/model/market_status.dart';
import 'package:investing/model/stock.dart';
import 'package:investing/model/stock_detail.dart';
import 'package:investing/use_case/stock_use_case.dart';

class StockController extends Controller<StockUseCase> {
  StockController(super.useCase);

  @override
  void onReady() {
    _initMarketStatus();
    _initIndexList();
    _initFavoriteList();
    super.onReady();
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

  void refreshFavoriteList({
    bool showOverlayLoading = true,
  }) async {
    Future load() async {
      final list = await useCase.requestStockList(
        useCase.loadStockList(),
      );
      favoriteList(list);
    }

    if (showOverlayLoading) {
      showOverlay(() async {
        return load();
      });
    } else {
      load();
    }
  }

  // Index
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
  Future _initIndexList() async {
    await refreshIndexList(_indexStockList);
  }

  final RxList<StockDetail> indexDetailList = <StockDetail>[].obs;
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

  Future updateFavoriteStock(Stock stock) async {
    await useCase.updateStock(stock);
  }

  Future removeFavoriteStock(Stock stock) {
    return useCase.removeStock(stock.index);
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
  Future<StockDetail> requestStockDetail(StockDetail stockDetail) {
    return useCase.requestStockDetail(
      stockDetail: stockDetail,
      dateTimeRange: stockDetail.dateTimeRangeList.first,
    );
  }

  Future<StockDividend?> requestStockDividend(Stock stock) async {
    try {
      return useCase.requestStockDividend(stock);
    } catch (e) {
      return null;
    }
  }
}
