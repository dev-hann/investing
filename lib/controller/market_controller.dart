import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/model/market.dart';
import 'package:investing/model/market_status.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/use_case/market_use_case.dart';

class MarketState extends Equatable {
  const MarketState({
    this.marketDataList = const [],
    this.marketPercentData = const {},
    this.marketStatus,
  });

  final List<MarketData> marketDataList;
  final Map<String, double> marketPercentData;
  final MarketStatus? marketStatus;

  MarketState copyWith({
    List<MarketData>? marketDataList,
    Map<String, double>? marketPercentData,
    MarketStatus? marketStatus,
  }) {
    return MarketState(
      marketDataList: marketDataList ?? this.marketDataList,
      marketPercentData: marketPercentData ?? this.marketPercentData,
      marketStatus: marketStatus ?? this.marketStatus,
    );
  }

  @override
  List<Object?> get props => [marketDataList, marketPercentData, marketStatus];
}

class MarketController extends Notifier<MarketState> {
  late final MarketUseCase useCase;
  final Map<String, List<double>> marketChartData = {};
  StreamSubscription<Map<String, double>>? _percentSubscription;
  Timer? _percentSaveTimer;
  Timer? _marketTimer;

  @override
  MarketState build() {
    useCase = ref.watch(marketUseCaseProvider);
    ref.onDispose(_dispose);
    unawaited(_init());
    return const MarketState();
  }

  void _dispose() {
    unawaited(_percentSubscription?.cancel());
    _percentSubscription = null;
    _percentSaveTimer?.cancel();
    _percentSaveTimer = null;
    _marketTimer?.cancel();
    _marketTimer = null;
  }

  Future<void> _init() async {
    await useCase.init();
    // Show the last-known-good heatmap immediately, then refresh.
    final cached = useCase.loadPercentData();
    if (cached.isNotEmpty) {
      state = state.copyWith(marketPercentData: cached);
    }
    await refreshMarketData();
    await _subscribePercentData();
  }

  Future<void> _subscribePercentData() async {
    final symbols = state.marketDataList
        .expand((sector) => sector.childeren.map((stock) => stock.name))
        .toSet()
        .toList();
    if (useCase.isRealTimeConfigured && symbols.isNotEmpty) {
      _percentSubscription = useCase.subscribePercentData(symbols).listen((
        delta,
      ) {
        state = state.copyWith(
          marketPercentData: {...state.marketPercentData, ...delta},
        );
        _schedulePercentSave();
      });
      return;
    }
    // No credentials (or nothing to subscribe to) — one-shot fallback.
    await refreshMarketPercentData();
  }

  Future<void> refreshMarketData() async {
    try {
      final data = await useCase.requestMarketData();
      state = state.copyWith(marketDataList: data);
    } catch (e) {
      // Network failure — keep the last-known sector tree.
      debugPrint('MarketController: market data refresh failed — $e');
    }
  }

  Future<void> refreshMarketPercentData() async {
    final data = await useCase.requestMarketPercentData();
    if (data.isEmpty) {
      // Keep the last-known-good map on empty responses.
      return;
    }
    state = state.copyWith(marketPercentData: data);
    unawaited(useCase.savePercentData(data));
  }

  void _schedulePercentSave() {
    _percentSaveTimer?.cancel();
    _percentSaveTimer = Timer(const Duration(seconds: 5), () {
      unawaited(useCase.savePercentData(state.marketPercentData));
    });
  }

  Future<Map<String, List<double>>> requestMarketChartData(
    List<String> symbolList,
  ) async {
    final Map<String, List<double>> res = {};
    final tmpSymbolList = <String>[];

    for (final symbol in symbolList) {
      if (marketChartData.containsKey(symbol)) {
        res[symbol] = marketChartData[symbol]!;
      } else {
        tmpSymbolList.add(symbol);
      }
    }
    if (tmpSymbolList.isNotEmpty) {
      final data = await useCase.requestChartData(symbolList);
      for (final entry in data.entries) {
        final key = entry.key;
        final value = entry.value;
        marketChartData[key] = value;
        res[key] = value;
      }
    }
    return res;
  }

  // Movers
  Future<List<Stock>> requestMovers(MarketMoverCategory category) {
    return useCase.requestMovers(category);
  }

  // MarketStatus
  Future<void> refreshMarketStatus() async {
    final MarketStatus status;
    try {
      status = await useCase.requestMarketStatus();
    } catch (e) {
      debugPrint('MarketController: market status refresh failed — $e');
      return;
    }
    state = state.copyWith(marketStatus: status);
    if (status.isOpened) {
      return;
    }
    // Wait until the pre-market opens, then refresh again.
    final leftDuration = status.preMarketOpen.difference(DateTime.now());
    if (leftDuration.isNegative || leftDuration == Duration.zero) {
      unawaited(refreshMarketStatus());
      return;
    }
    _marketTimer?.cancel();
    _marketTimer = Timer(leftDuration, () {
      unawaited(refreshMarketStatus());
    });
  }
}

final marketControllerProvider =
    NotifierProvider<MarketController, MarketState>(MarketController.new);
