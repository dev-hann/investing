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
  static StockController find() => Get.find();

  @override
  void onReady() async {
    await useCase.init();
    super.onReady();
    _initIndexList();
    _initFavoriteList();
  }

  // Favorite
  List<Stock>? _favoriteList;
  List<Stock>? get favoriteList => _favoriteList;
  bool isContains(Stock stock) {
    if (_favoriteList == null) {
      return false;
    }
    final index =
        _favoriteList!.indexWhere((element) => element.isEquals(stock));
    return index != -1;
  }

  Future<void> _initFavoriteList() async {
    useCase.favoriteListStream().listen((event) async {
      _favoriteList = event;
      update();
    });
    refreshFavoriteList();
  }

  Future refreshFavoriteList() async {
    List<Stock> list = useCase.loadStockList();
    list = await useCase.requestStockList(list);
    list.sort();
    _favoriteList = list;
    update();
  }

  void refreshRealTimeFavoriteList() async {
    await refreshFavoriteList();
    await Future.delayed(const Duration(seconds: 2));
    refreshRealTimeFavoriteList();
  }

  // Future updateFavoriteList(List<Stock> list) async {
  //   favoriteList(list);
  //   for (final stock in list) {
  //     updateFavoriteStock(stock);
  //   }
  // }

  Future toggleFavoriteStock(Stock stock) async {
    if (isContains(stock)) {
      await useCase.removeStock(stock);
    } else {
      await useCase.updateStock(stock);
    }
  }

  // Index
  //TODO: make it edit by option button

  List<Stock> _indexList = RxList([
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
  List<Stock> get indexList => _indexList;
  Future _initIndexList() async {
    await refreshIndexList();
  }

  Future refreshIndexList() async {
    final res = await useCase.requestStockList(indexList);
    _indexList = res;
    update();
  }

  Future refreshRealTimeIndexList() async {
    await refreshIndexList();
    await Future.delayed(const Duration(seconds: 10));
    refreshRealTimeIndexList();
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
