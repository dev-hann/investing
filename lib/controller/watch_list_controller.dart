import 'package:investing/controller/controller.dart';
import 'package:investing/data/db/data_base.dart';
import 'package:investing/data/service/service.dart';
import 'package:investing/model/stock.dart';
import 'package:get/get.dart';

class WatchListController extends Controller {
  static WatchListController find() => Get.find<WatchListController>();

  final List<Stock> watchList = <Stock>[];

  final DataBase watchListDB = DataBase("WatchList");
  final StockService stockService = StockService();
  @override
  void onReady() async {
    await watchListDB.init();
    watchListDB.stream.listen((event) {
      refreshState();
    });
    super.onReady();
  }

  void _loadStockList() {
    final list =
        watchListDB.loadStockList().map((e) => Stock.fromMap(e)).toList();
    list.sort();
    watchList.clear();
    watchList.addAll(list);
    update();
  }

  void refreshState() {
    _loadStockList();
  }

  Future updateStock(Stock stock) {
    return watchListDB.updateStock(stock);
  }

  Future removeStock(String stockIndex) {
    return watchListDB.removeStock(stockIndex);
  }

  Future toggleBookmark(Stock stock) async {
    if (watchList.contains(stock)) {
      await removeStock(stock.index);
    } else {
      await updateStock(stock);
    }
  }

  Future<List<Stock>> searchStock(String query) async {
    final list = await stockService.searchStock(query);
    final searchedList = <Stock>[];
    for (int index = 0; index < list.length; ++index) {
      final item = Stock.dto(list[index]);
      if (!searchedList.contains(item)) {
        searchedList.add(item);
      }
    }
    return searchedList;
  }
}
