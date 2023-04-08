part of service;

class StockService extends IVService {
  Future<List> searchStock(String query) {
    return _search(SearchType.stock, query: query);
  }

  Future<Response> requestDowIndex({
    required String? fromDate,
    required String? toDate,
  }) {
    return _requestMajorIndex(
      symbol: "INDU",
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  Future<Response> requestNasdaqIndex({
    required String? fromDate,
    required String? toDate,
  }) {
    return _requestMajorIndex(
      symbol: "COMP",
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  Future<Response> requestSnpIndex({
    required String? fromDate,
    required String? toDate,
  }) {
    return _requestMajorIndex(
      symbol: "SPX",
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  Future<Response> _requestMajorIndex({
    required String symbol,
    required String? fromDate,
    required String? toDate,
  }) async {
    final url =
        "https://api.nasdaq.com/api/quote/$symbol/chart?assetclass=index";
    // const url = "https://api.nasdaq.com/api/quote/indices";
    return get(
      url,
      query: {
        "fromDate": fromDate,
        "toDate": toDate,
      },
    );
  }

  Future<Response> request2YTreasury({
    required String fromDate,
    required String toDate,
  }) {
    return _requestTreasury(
      symbol: "CMTN2Y",
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  Future<Response> request20YTreasury({
    required String fromDate,
    required String toDate,
  }) {
    return _requestTreasury(
      symbol: "CMTN20Y",
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  Future<Response> _requestTreasury({
    required String symbol,
    required String fromDate,
    required String toDate,
  }) async {
    final url =
        "https://api.nasdaq.com/api/quote/$symbol/chart?assetclass=fixedincome";
    return get(
      url,
      query: {
        "fromdate": fromDate,
        "todate": toDate,
      },
    );
  }

  Future<Response> requestCrudeOil({
    required String fromDate,
    required String toDate,
  }) {
    return _requestCommodity(
      symbol: "CL%3ANMX",
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  Future<Response> requestGold({
    required String fromDate,
    required String toDate,
  }) {
    return _requestCommodity(
      symbol: "GC%3ACMX",
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  Future<Response> requestCopper({
    required String fromDate,
    required String toDate,
  }) {
    return _requestCommodity(
      symbol: "hg%3Acmx",
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  Future<Response> requestNaturalGas({
    required String fromDate,
    required String toDate,
  }) {
    return _requestCommodity(
      symbol: "ng%3Anmx",
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  Future<Response> _requestCommodity({
    required String symbol,
    required String fromDate,
    required String toDate,
  }) async {
    final url =
        "https://api.nasdaq.com/api/quote/$symbol/chart?assetclass=commodities";
    return get(
      url,
      query: {
        "fromdate": fromDate,
        "todate": toDate,
      },
    );
  }
}
