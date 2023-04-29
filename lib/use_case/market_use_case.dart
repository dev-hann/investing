import 'package:investing/model/market.dart';
import 'package:investing/model/market_status.dart';
import 'package:investing/repo/market/market_repo.dart';
import 'package:investing/use_case/use_case.dart';
import 'package:investing/util/number_format.dart';

class MarketUseCase extends UseCase<MarketRepo> {
  MarketUseCase(super.repo);

  Future<List<MarketData>> requestMarketData() async {
    final list = List.from(await repo.requestMarketData());
    return list.map((e) => MarketData.fromMap(e)).toList();
  }

  Future<Map<String, double>> requestMarketPercentData() async {
    final res = await repo.requestMarketPercentData();
    return Map<String, double>.from(res);
  }

  Future<Map<String, double>> refreshMarketPercentRealTimeData(
      List<String> symbolList) async {
    final res = await repo.requestMarketPercentRealTimeData(
        symbolList.map((e) => "$e|STOCKS").toList());
    final dataList = List.from(res["data"]["records"]);
    final Map<String, double> map = {};
    for (final data in dataList) {
      final symbol = List.from(data["ticker"]).first;
      final percent = IVNumberFormat(data["pctChange"]).toDouble();
      map[symbol] = percent;
    }
    return map;
  }

  Future<Map<String, List<dynamic>>> requestChartData(
      List<String> symbolList) async {
    return Map<String, List<dynamic>>.from(
        await repo.requestChartData(symbolList));
  }

  Future<MarketStatus> requestMarketStatus() async {
    final res = await repo.requestMarketStatus();
    return MarketStatus.fromMap(res);
  }
}
