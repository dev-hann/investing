import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/model/date_time_range.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/model/stock/stock_chart.dart';
import 'package:investing/model/stock/stock_company.dart';
import 'package:investing/model/stock/stock_dividend.dart';
import 'package:investing/model/stock/stock_financial.dart';
import 'package:investing/use_case/stock_use_case.dart';

class StockState extends Equatable {
  const StockState({this.favoriteList, this.indexList = const []});

  /// `null` means the list has not been loaded yet (loading UI).
  final List<Stock>? favoriteList;
  final List<Stock> indexList;

  StockState copyWith({List<Stock>? favoriteList, List<Stock>? indexList}) {
    return StockState(
      favoriteList: favoriteList ?? this.favoriteList,
      indexList: indexList ?? this.indexList,
    );
  }

  @override
  List<Object?> get props => [favoriteList, indexList];
}

class StockController extends Notifier<StockState> {
  late final StockUseCase useCase;
  StreamSubscription<List<Stock>>? _favoriteSubscription;

  static List<Stock> defaultIndexList() => [
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
  ];

  @override
  StockState build() {
    useCase = ref.watch(stockUseCaseProvider);
    ref.onDispose(() => unawaited(_favoriteSubscription?.cancel()));
    unawaited(_init());
    return StockState(indexList: defaultIndexList());
  }

  Future<void> _init() async {
    await useCase.init();
    unawaited(_initFavoriteList());
    unawaited(_initIndexList());
  }

  // Favorite
  bool isContains(Stock stock) {
    final list = state.favoriteList;
    if (list == null) {
      return false;
    }
    return list.any((element) => element.isEquals(stock));
  }

  Future<void> _initFavoriteList() async {
    _favoriteSubscription = useCase.favoriteListStream().listen((event) {
      state = state.copyWith(favoriteList: event);
    });
    unawaited(refreshFavoriteList());
  }

  Future<void> refreshFavoriteList() async {
    List<Stock> list = useCase.loadStockList();
    list = await useCase.requestStockList(list);
    list.sort();
    state = state.copyWith(favoriteList: list);
  }

  void refreshRealTimeFavoriteList() async {
    await refreshFavoriteList();
    await Future<void>.delayed(const Duration(seconds: 2));
    refreshRealTimeFavoriteList();
  }

  Future<void> toggleFavoriteStock(Stock stock) async {
    if (isContains(stock)) {
      await useCase.removeStock(stock);
    } else {
      await useCase.updateStock(stock);
    }
  }

  // Index
  //TODO: make it edit by option button

  Future<void> _initIndexList() async {
    await refreshIndexList();
  }

  Future<void> refreshIndexList() async {
    final res = await useCase.requestStockList(state.indexList);
    state = state.copyWith(indexList: res);
  }

  Future<void> refreshRealTimeIndexList() async {
    await refreshIndexList();
    await Future<void>.delayed(const Duration(seconds: 10));
    unawaited(refreshRealTimeIndexList());
  }

  // Stock Detail
  Future<StockDividend?> requestStockDividend(Stock stock) async {
    try {
      return await useCase.requestStockDividend(
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
    return useCase.requestStockFinancial(symbol: stock.symbol, type: type);
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

  Future<StockCompany?> requestStockCompany(Stock stock) {
    return useCase.requestStockCompany(stock.symbol);
  }
}

final stockControllerProvider = NotifierProvider<StockController, StockState>(
  StockController.new,
);
