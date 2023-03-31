part of service;

class StockService extends IVService {
  Future<List> searchStock(String query) {
    return _search(SearchType.stock, query: query);
  }
}
