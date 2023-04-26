import 'package:dio/dio.dart';
import 'package:investing/data/service/service.dart';

class MarketService extends IVService {
  Future<Response> requestMarketData() {
    const url = "https://finviz.com/maps/sec.json";
    return get(url);
  }
}
