import 'package:dio/dio.dart';
import 'package:investing/data/service/service.dart';

class MarketService extends IVService {
  Future<Response> requestMarketData() {
    const url = "https://finviz.com/maps/sec.json";
    return get(url);
  }

  Future<Response> requestMarkePercenttData() {
    const url = "https://finviz.com/api/map_perf.ashx?t=sec";
    return get(url);
  }

  Future<Response> requestStockList(List<String> symbolList) {
    final q = symbolList.map((e) => "symbol=$e").join("&");
    final url = "https://api.nasdaq.com/api/quote/basic?$q";
    return get(
      url,
    );
  }

  Future<Response> requestChartData(List<String> symbolList) {
    final q = symbolList.join(",");
    const url = "https://finviz.com/api/map_sparklines.ashx";
    return get(
      url,
      query: {
        "t": q,
        "ty": "sec",
      },
    );
  }
}
