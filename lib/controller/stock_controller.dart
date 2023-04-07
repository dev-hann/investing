import 'package:hive_flutter/hive_flutter.dart';
import 'package:investing/controller/controller.dart';
import 'package:investing/data/db/data_base.dart';
import 'package:investing/data/service/service.dart';
import 'package:investing/model/stock.dart';
import 'package:get/get.dart';

class StockController extends Controller {
  static StockController find() => Get.find<StockController>();
  final List<Stock> indexList = <Stock>[
    const Stock(
      name: "Nasdaq",
      symbol: "",
      price: 20,
      stockTypeIndex: 0,
    ),
    const Stock(
      name: "S&P500",
      symbol: "",
      price: 30,
      stockTypeIndex: 0,
    ),
  ];
  final List<Stock> watchList = <Stock>[];

  final DataBase watchListDB = DataBase("WatchList");
  Stream<BoxEvent> get watchListStream => watchListDB.stream;

  final StockService stockService = StockService();
  @override
  void onReady() async {
    await watchListDB.init();
    watchListStream.listen((event) {
      refreshState();
    });
    refreshState();
    super.onReady();
  }

  void refreshState() {
    final list =
        watchListDB.loadStockList().map((e) => Stock.fromMap(e)).toList();
    list.sort();
    watchList.clear();
    watchList.addAll(list);
    update();
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
