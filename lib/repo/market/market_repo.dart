library market_repo;

import 'package:investing/data/service/market_service.dart';
import 'package:investing/repo/repo.dart';
part './market_impl.dart';

abstract class MarketRepo extends Repo {
  Future<dynamic> requestMarketData();

  Future<dynamic> requestMarketPercentData();

  Future<dynamic> requestMarketPercentRealTimeData(List<String> symbolList);

  Future<dynamic> requestChartData(List<String> symbolList);

  Future<dynamic> requestMarketStatus();
}
