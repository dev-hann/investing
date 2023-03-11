import 'package:dividends_manager/controller/controller.dart';
import 'package:dividends_manager/data/db/data_base.dart';
import 'package:dividends_manager/data/service/stock_service.dart';
import 'package:dividends_manager/model/stock.dart';
import 'package:get/get.dart';

class StockController extends Controller {
  static StockController find() => Get.find<StockController>();

  final List<Stock> stockList = <Stock>[];

  final DataBase stcokDB = DataBase("Stock");
  final StockService stockService = StockService();
  @override
  void onReady() async {
    await stcokDB.init();
    stcokDB.stream.listen((event) {
      refreshState();
    });
    super.onReady();
  }

  void _loadStockList() {
    final list = stcokDB.loadStockList().map((e) => Stock.fromMap(e)).toList();
    list.sort();
    stockList.clear();
    stockList.addAll(list);
    update();
  }

  void refreshState() {
    _loadStockList();
  }

  Future updateStock(Stock stock) {
    return stcokDB.updateStock(stock);
  }

  Future removeStock(String stockIndex) {
    return stcokDB.removeStock(stockIndex);
  }

  Future toggleBookmark(Stock stock) async {
    if (stockList.contains(stock)) {
      await removeStock(stock.index);
    } else {
      await updateStock(stock);
    }
  }

  Future<List<Stock>> searchStock(String query) async {
    final res = await stockService.search(query);
    final list = List<Map<String, dynamic>>.from(
      res["data"]["symbol"]["value"],
    );
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
