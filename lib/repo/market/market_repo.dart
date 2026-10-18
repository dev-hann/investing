library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/data/db/data_base.dart';
import 'package:investing/data/service/alpaca_service.dart';
import 'package:investing/data/service/market_service.dart';
import 'package:investing/model/market.dart';
import 'package:investing/model/market_status.dart';
import 'package:investing/model/quote.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/repo/repo.dart';
import 'package:investing/util/number_format.dart';
part 'market_impl.dart';

abstract class MarketRepo extends Repo {
  Future<List<MarketData>> requestMarketData();

  Future<Map<String, double>> requestMarketPercentData();

  Future<Map<String, List<double>>> requestChartData(List<String> symbolList);

  Future<MarketStatus> requestMarketStatus();

  /// Top movers (gainers / losers / most active) from the Nasdaq screener.
  Future<List<Stock>> requestMovers(MarketMoverCategory category);

  /// Whether Alpaca credentials were provided via `--dart-define`.
  bool get isRealTimeConfigured;

  /// Previous daily close per symbol (Alpaca IEX snapshots).
  Future<Map<String, double>> requestPrevCloses(List<String> symbols);

  /// Live quotes from the Alpaca IEX websocket.
  Stream<Quote> subscribeQuoteStream(List<String> symbols);

  /// Last-known-good sector percent map (Hive, may be empty).
  Map<String, double> loadPercentData();

  Future<void> savePercentData(Map<String, double> data);
}

final marketRepoProvider = Provider<MarketRepo>((ref) => MarketImpl());
