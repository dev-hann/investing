import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/model/market.dart';
import 'package:investing/model/market_status.dart';
import 'package:investing/repo/market/market_repo.dart';
import 'package:investing/use_case/use_case.dart';
import 'package:investing/util/number_format.dart';

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

  Future<Map<String, double>> refreshMarketPercentRealTimeData(
    List<String> symbolList,
  ) async {
    final res = await repo.requestMarketPercentRealTimeData(
      symbolList.map((e) => '$e|STOCKS').toList(),
    ) as Map<String, dynamic>;
    final dataList = List<Map<String, dynamic>>.from(
      (res['data'] as Map<String, dynamic>)['records'] as List<dynamic>,
    );
    final Map<String, double> map = {};
    for (final data in dataList) {
      final symbol =
          List<dynamic>.from(data['ticker'] as List<dynamic>).first as String;
      final percent = IVNumberFormat(data['pctChange'] as String?).toDouble();
      map[symbol] = percent;
    }
    return map;
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
