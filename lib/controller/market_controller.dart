import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/model/market.dart';
import 'package:investing/model/market_status.dart';
import 'package:investing/use_case/market_use_case.dart';
import 'package:investing/widget/snackbar.dart';

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

  @override
  MarketState build() {
    useCase = ref.watch(marketUseCaseProvider);
    unawaited(refreshMarketData());
    return const MarketState();
  }

  Future<void> refreshMarketData() async {
    final data = await useCase.requestMarketData();
    state = state.copyWith(marketDataList: data);
  }

  Future<void> refreshMarketPercentData() async {
    final data = await useCase.requestMarketPercentData();
    state = state.copyWith(marketPercentData: data);
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
        final value = List<num>.from(entry.value)
            .map((e) => e.toDouble())
            .toList();
        marketChartData[key] = value;
        res[key] = value;
      }
    }
    return res;
  }

  Future<void> refreshMarketPercentRealTimeData() async {
    Map<String, double> percentData = state.marketPercentData;
    if (percentData.isEmpty) {
      percentData = await useCase.requestMarketPercentData();
    }
    final symbolList = percentData.keys.toList();
    final Map<String, double> map = {};
    for (int index = 0; index < symbolList.length; index += 100) {
      final tmpList = symbolList.sublist(
        index,
        min(index + 100, symbolList.length),
      );
      final data = await useCase.refreshMarketPercentRealTimeData(tmpList);
      map.addEntries(data.entries);
    }
    state = state.copyWith(marketPercentData: map);
    await Future<void>.delayed(const Duration(seconds: 5));
    unawaited(refreshMarketPercentRealTimeData());
  }

  // MarketStatus
  Timer? _marketTimer;

  Future<void> refreshMarketStatus() async {
    final status = await useCase.requestMarketStatus();
    state = state.copyWith(marketStatus: status);
    if (!status.isOpened) {
      final now = DateTime.now();
      final leftDuration = now.difference(status.preMarketOpen);
      _marketTimer = Timer.periodic(leftDuration, (_) {
        // Open Market!
        unawaited(refreshMarketStatus());
        _marketTimer?.cancel();
      });
      return;
    }
    showIVSnackbar('Market Status', 'Market is Opened!');
  }
}

final marketControllerProvider =
    NotifierProvider<MarketController, MarketState>(MarketController.new);
