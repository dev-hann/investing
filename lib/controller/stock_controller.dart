import 'dart:async';

import 'package:get/get.dart';
import 'package:investing/controller/controller.dart';
import 'package:investing/data/db/data_base.dart';
import 'package:investing/model/stock/stock_company.dart';
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
    _initIndexList();
    _initFavoriteList();
  }

  static StockController find() => Get.find<StockController>();

  Stream<IVDataBaseEvent<Stock>> get favoriteStream => useCase.favoriteStream();

  // Favorite
  final RxList<Stock> favoriteList = RxList<Stock>();
  Future<void> _initFavoriteList() async {
    favoriteStream.listen((event) async {
      refreshFavoriteList(updateData: !event.deleted);
    });
    refreshFavoriteList();
  }

  void refreshFavoriteList({
    bool updateData = true,
  }) async {
    List<Stock> list = useCase.loadStockList();
    if (updateData) {
      list = await useCase.requestStockList(list);
    }
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
  final RxList<Stock> indexList = RxList([
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
  ]);
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
        dateTimeRange:
            IVDateTimeRange.fromRangeType(stock.chartRangeTypeList.first),
      );
      list.add(res);
    }
    indexChartList(list);
  }

  // MarketStatus
  final Rx<MarketStatus?> marketStatus = Rx(null);

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
    required IVDateTimeRange? dateTimeRange,
  }) {
    return useCase.requestStockChart(
      symbol: stock.symbol,
      asset: stock.asset,
      dateTimeRange: dateTimeRange,
    );
  }

  Future<StockCompany?> reqeustStockCompany(Stock stock) {
    return useCase.reqeustStockCompany(stock.symbol);
  }
}
