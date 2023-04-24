part of service;

class StockService extends IVService {
  Future<Response> searchStock(String query) async {
    const url = "https://api.nasdaq.com/api/search/site";
    return get(
      url,
      query: {
        "query": query,
      },
    );
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

  Future<Response> requestStockList(List<String> symbolList) {
    final q = symbolList.map((e) => "symbol=$e").join("&");
    final url = "https://api.nasdaq.com/api/quote/basic?$q";
    return get(
      url,
    );
  }

  Future<Response> requestStockDividend({
    required String symbol,
    required String asset,
  }) async {
    final url = "https://api.nasdaq.com/api/quote/$symbol/dividends";
    return get(
      url,
      query: {
        "assetclass": asset,
      },
    );
  }

  Future<Response> requestStockFinancial({
    required String symbol,
    required int typeIndex,
  }) {
    final url = "https://api.nasdaq.com/api/company/$symbol/financials";
    return get(
      url,
      query: {
        "frequency": typeIndex + 1,
      },
    );
  }

  Future<Response> requestStockCahrt({
    required String symbol,
    required String asset,
    required String? fromDate,
    required String? toDate,
  }) {
    final url = "https://api.nasdaq.com/api/quote/$symbol/chart";
    return get(
      url,
      query: {
        "assetclass": asset,
        "fromdate": fromDate,
        "todate": toDate,
      },
    );
  }
}
