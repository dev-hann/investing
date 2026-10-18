part of 'service.dart';

class StockService extends IVService {
  Future<Response<dynamic>> searchStock(String query) async {
    const url = 'https://api.nasdaq.com/api/search/site';
    return get(url, query: {'query': query});
  }

  Future<Response<dynamic>> requestStock({
    required String symbol,
    required String assetClass,
  }) async {
    final url = 'https://api.nasdaq.com/api/quote/$symbol/info';
    return get(url, query: {'assetClass': assetClass});
  }

  Future<Response<dynamic>> requestStockList(List<String> symbolList) {
    final q = symbolList.map((e) => 'symbol=$e').join('&');
    final url = 'https://api.nasdaq.com/api/quote/basic?$q';
    return get(url);
  }

  Future<Response<dynamic>> requestStockDividend({
    required String symbol,
    required String asset,
  }) async {
    final url = 'https://api.nasdaq.com/api/quote/$symbol/dividends';
    return get(url, query: {'assetclass': asset});
  }

  Future<Response<dynamic>> requestStockFinancial({
    required String symbol,
    required int typeIndex,
  }) {
    final url = 'https://api.nasdaq.com/api/company/$symbol/financials';
    return get(url, query: {'frequency': typeIndex + 1});
  }

  Future<Response<dynamic>> requestStockCahrt({
    required String symbol,
    required String asset,
    required String? fromDate,
    required String? toDate,
  }) {
    final url = 'https://api.nasdaq.com/api/quote/$symbol/chart';
    return get(
      url,
      query: {'assetclass': asset, 'fromdate': fromDate, 'todate': toDate},
    );
  }

  Future<Response<dynamic>> requestStockCompany(String symbol) {
    final url = 'https://api.nasdaq.com/api/company/$symbol/company-profile';
    return get(url);
  }
}
