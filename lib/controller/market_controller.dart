import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:investing/controller/controller.dart';
import 'package:investing/model/market.dart';
import 'package:investing/model/market_status.dart';
import 'package:investing/use_case/market_use_case.dart';

class MarketController extends Controller<MarketUseCase> {
  MarketController(super.useCase);

  static MarketController find() => Get.find<MarketController>();

  @override
  void onReady() {
    refreshMarketStatus().then((value) {
      final marketStatusValue = marketStatus.value!;
      if (marketStatusValue.isOpened) {
        return refreshMarketPercentRealTimeData();
      }
      return refreshMarketPercentData();
    });
    refreshMarketData();
    super.onReady();
  }

  final RxList<MarketData> marketDataList = RxList();
  Future refreshMarketData() async {
    final data = await useCase.requestMarketData();
    marketDataList(data);
  }

  final RxMap<String, double> marketPercentData = RxMap();
  Future refreshMarketPercentData() async {
    final data = await useCase.requestMarketPercentData();
    marketPercentData(data);
  }

  final RxMap<String, List<double>> marketChartData = RxMap();
  Future<Map<String, List<double>>> requestMarketChartData(
      List<String> symbolList) async {
    final Map<String, List<double>> res = {};
    final tmpSymbolList = [];

    for (final symbol in symbolList) {
      if (marketChartData.containsKey(symbolList)) {
        res[symbol] = marketChartData[symbol]!;
      } else {
        tmpSymbolList.add(symbol);
      }
    }
    if (tmpSymbolList.isNotEmpty) {
      final data = await useCase.requestChartData(symbolList);
      for (final entry in data.entries) {
        final key = entry.key;
        final value =
            List<num>.from(entry.value).map((e) => e.toDouble()).toList();
        marketChartData[key] = value;
        res[key] = value;
      }
    }
    return res;
  }

  Future refreshMarketPercentRealTimeData() async {
    Map<String, double> percentData = marketPercentData;
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
    marketPercentData(map);
    await Future.delayed(const Duration(seconds: 5));
    refreshMarketPercentRealTimeData();
  }

  // MarketStatus
  final Rxn<MarketStatus?> marketStatus = Rxn();
  late Timer _marketTimer;
  Future refreshMarketStatus() async {
    final status = await useCase.requestMarketStatus();
    marketStatus(status);
    if (!status.isOpened) {
      final now = DateTime.now();
      final leftDuration = now.difference(status.preMarketOpen);
      _marketTimer = Timer.periodic(leftDuration, (_) {
        // Open Market!
        refreshMarketStatus();
        _marketTimer.cancel();
      });
      return;
    }
    Get.snackbar("Market Status", "Market is Opened!");
  }
}
