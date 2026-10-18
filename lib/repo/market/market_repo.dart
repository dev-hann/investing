library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/data/db/data_base.dart';
import 'package:investing/data/service/alpaca_service.dart';
import 'package:investing/data/service/market_service.dart';
import 'package:investing/model/market.dart';
import 'package:investing/model/market_status.dart';
import 'package:investing/model/quote.dart';
import 'package:investing/repo/repo.dart';
part 'market_impl.dart';

abstract class MarketRepo extends Repo {
  Future<List<MarketData>> requestMarketData();

  Future<Map<String, double>> requestMarketPercentData();

  Future<Map<String, List<double>>> requestChartData(List<String> symbolList);

  Future<MarketStatus> requestMarketStatus();

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
