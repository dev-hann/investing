import 'dart:async';

import 'package:get/get.dart';
import 'package:investing/controller/controller.dart';
import 'package:investing/model/stock/stock_company.dart';
import 'package:investing/model/date_time_range.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/model/stock/stock_chart.dart';
import 'package:investing/model/stock/stock_dividend.dart';
import 'package:investing/model/stock/stock_financial.dart';
import 'package:investing/use_case/stock_use_case.dart';

class StockController extends Controller<StockUseCase> {
  StockController(super.useCase);
  static StockController find() => Get.find<StockController>();

  @override
  void onReady() async {
    await useCase.init();
    super.onReady();
    _initIndexList();
    _initFavoriteList();
  }

  // Favorite
  final RxBool favoriteLoading = true.obs;
  final RxList<Stock> favoriteList = RxList<Stock>();
  Future<void> _initFavoriteList() async {
    useCase.favoriteStream().listen((event) async {
      if (event.deleted) {
        favoriteList.removeWhere((element) => event.key == element.index);
        return;
      }
      refreshFavoriteList();
    });
    refreshFavoriteList();
  }

  Future refreshFavoriteList() async {
    List<Stock> list = useCase.loadStockList();
    list = await useCase.requestStockList(list);
    list.sort();
    favoriteList(list);
    favoriteLoading(false);
  }

  void refreshRealTimeFavoriteList() async {
    await refreshFavoriteList();
    await Future.delayed(const Duration(seconds: 2));
    refreshRealTimeFavoriteList();
  }

  Future updateFavoriteList(List<Stock> list) async {
    favoriteList(list);
    for (final stock in list) {
      updateFavoriteStock(stock);
    }
  }

  Future updateFavoriteStock(Stock stock) {
    return useCase.updateStock(stock);
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

  final RxBool indexLoading = true.obs;
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
    indexLoading(false);
  }

  Future refreshRealTimeIndexList() async {
    await refreshIndexList();
    await Future.delayed(const Duration(seconds: 10));
    refreshRealTimeIndexList();
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
