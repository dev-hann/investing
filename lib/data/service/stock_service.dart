part of service;

class StockService extends IVService {
  Future<List> searchStock(String query) {
    return _search(SearchType.stock, query: query);
  }

  Future<dynamic> requestMajorIndexList() async {
    const url =
        "https://api.nasdaq.com/api/quote/indices?symbol=COMP&symbol=SPX&symbol=INDU";
    final res = await get(url);
    return res.data;
  }
}
