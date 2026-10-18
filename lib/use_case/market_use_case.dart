import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/model/market.dart';
import 'package:investing/model/market_status.dart';
import 'package:investing/repo/market/market_repo.dart';
import 'package:investing/use_case/use_case.dart';

/// percent = (price / previousClose - 1) * 100
double percentChange({required double price, required double base}) {
  return (price / base - 1) * 100;
}

class MarketUseCase extends UseCase<MarketRepo> {
  MarketUseCase(super.repo);

  Future<List<MarketData>> requestMarketData() async {
    final list = List<dynamic>.from(
      await repo.requestMarketData() as List<dynamic>,
    );
    return list.map(MarketData.fromMap).toList();
  }

  Future<Map<String, double>> requestMarketPercentData() async {
    final res = await repo.requestMarketPercentData();
    return Map<String, double>.from(res as Map<dynamic, dynamic>);
  }

  bool get isRealTimeConfigured => repo.isRealTimeConfigured;

  Map<String, double> loadPercentData() {
    return repo.loadPercentData();
  }

  Future<void> savePercentData(Map<String, double> data) {
    return repo.savePercentData(data);
  }

  /// Emits single-symbol percent deltas computed from live Alpaca quotes:
  /// each event is `{symbol: percent}` to be merged into the current map.
  ///
  /// Yields nothing when quotes are not configured or previous closes are
  /// unavailable — callers should fall back to [requestMarketPercentData].
  Stream<Map<String, double>> subscribePercentData(
    List<String> symbols,
  ) async* {
    if (symbols.isEmpty || !repo.isRealTimeConfigured) {
      return;
    }
    final Map<String, double> prevCloses;
    try {
      prevCloses = await repo.requestPrevCloses(symbols);
    } catch (e) {
      debugPrint('MarketUseCase: prev closes unavailable — $e');
      return;
    }
    if (prevCloses.isEmpty) {
      return;
    }
    await for (final quote in repo.subscribeQuoteStream(symbols)) {
      final base = prevCloses[quote.symbol];
      if (base == null || base <= 0 || quote.price <= 0) {
        continue;
      }
      yield {quote.symbol: percentChange(price: quote.price, base: base)};
    }
  }

  Future<Map<String, List<dynamic>>> requestChartData(
    List<String> symbolList,
  ) async {
    return Map<String, List<dynamic>>.from(
      await repo.requestChartData(symbolList) as Map<dynamic, dynamic>,
    );
  }

  Future<MarketStatus> requestMarketStatus() async {
    final res = await repo.requestMarketStatus();
    return MarketStatus.fromMap(res as Map<String, dynamic>);
  }
}

final marketUseCaseProvider = Provider(
  (ref) => MarketUseCase(ref.watch(marketRepoProvider)),
);
