import 'dart:math';

import 'package:get/get.dart';
import 'package:investing/controller/controller.dart';
import 'package:investing/model/market.dart';
import 'package:investing/use_case/market_use_case.dart';

class MarketController extends Controller<MarketUseCase> {
  MarketController(super.useCase);

  static MarketController find() => Get.find<MarketController>();
  final RxList<MarketData> marketDataList = RxList();
  final RxMap<String, double> marketPercentData = RxMap();
  final RxMap<String, List<double>> marketChartData = RxMap();

  @override
  void onReady() {
    refreshMarketData();
    refreshMarketPercentData();
    super.onReady();
  }

  Future refreshMarketData() async {
    final data = await useCase.requestMarketData();
    marketDataList(data);
  }

  Future refreshMarketPercentData() async {
    final data = await useCase.requestMarketPercentData();
    marketPercentData(data);
  }

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
  }
}
