part of service;

class StockService extends Service {
  Future<List> searchStock(String query) {
    return _search(SearchType.stock, query: query);
  }
}
