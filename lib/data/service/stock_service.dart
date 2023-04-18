part of service;

class StockService extends IVService {
  Future<List> searchStock(String query) async {
    const url = "https://api.nasdaq.com/api/search/site";
    final res = await get(
      url,
      query: {
        "query": query,
      },
    );
    return List.from(res.data["data"]["symbol"]["value"]);
  }

  Future<Response> requestStockWithChart({
    required String symbol,
    required String assetClass,
    required String? fromDate,
    required String? toDate,
  }) async {
    final url = "https://api.nasdaq.com/api/quote/$symbol/chart";
    return get(
      url,
      query: {
        "assetClass": assetClass,
        "fromdate": fromDate,
        "todate": toDate,
      },
    );
  }

  Future<Response> requestStock({
    required String symbol,
    required String assetClass,
  }) async {
    final url = "https://api.nasdaq.com/api/quote/$symbol/info";
    return get(
      url,
      query: {
        "assetClass": assetClass,
      },
    );
  }

  Future<Response> requestMarketStatus() {
    const url = "https://api.nasdaq.com/api/market-info";
    return get(url);
  }
}
