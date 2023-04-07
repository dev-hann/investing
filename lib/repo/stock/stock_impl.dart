part of stock_repo;

class StockImpl extends StockRepo {
  final StockService service = StockService();

  final DataBase watchListDB = DataBase("WatchList");

  @override
  Future init() async {
    await watchListDB.init();
    return super.init();
  }

  @override
  Stream watchListStream() {
    return watchListDB.stream;
  }

  @override
  List loadStockList() {
    return watchListDB.loadStockList();
  }

  @override
  Future removeStock(String index) {
    return watchListDB.removeStock(index);
  }

  @override
  Future updateStock(Stock data) {
    return watchListDB.updateStock(data);
  }

  @override
  Future<List> searchStock(String query) {
    return service.searchStock(query);
  }

  @override
  Future<List> requestCommodityIndexList() async {
    return [];
  }

  @override
  Future<List> requestFixedIncomeIndexList() async {
    return [];
  }

  @override
  Future<List> requestMajorIndexList() async {
    final data = await service.requestMajorIndexList();
    final list = data["data"];
    return list;
  }
}
