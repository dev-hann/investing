import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/model/market.dart';
import 'package:investing/model/market_status.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/repo/market/market_repo.dart';
import 'package:investing/use_case/use_case.dart';

/// percent = (price / previousClose - 1) * 100
double percentChange({required double price, required double base}) {
  return (price / base - 1) * 100;
}

class MarketUseCase extends UseCase<MarketRepo> {
  MarketUseCase(super.repo);

  Future<List<MarketData>> requestMarketData() {
    return repo.requestMarketData();
  }

  Future<Map<String, double>> requestMarketPercentData() {
    return repo.requestMarketPercentData();
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

  Future<Map<String, List<double>>> requestChartData(List<String> symbolList) {
    return repo.requestChartData(symbolList);
  }

  Future<MarketStatus> requestMarketStatus() {
    return repo.requestMarketStatus();
  }

  Future<List<Stock>> requestMovers(MarketMoverCategory category) {
    return repo.requestMovers(category);
  }
}

final marketUseCaseProvider = Provider(
  (ref) => MarketUseCase(ref.watch(marketRepoProvider)),
);
