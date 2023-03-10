import 'package:dividends_manager/controller/controller.dart';
import 'package:dividends_manager/data/db/data_base.dart';
import 'package:dividends_manager/model/stock.dart';
import 'package:get/get.dart';

class StockController extends Controller {
  static StockController find() => Get.find<StockController>();

  final RxList<Stock> stockList = RxList<Stock>([]);

  final DataBase stcokDB = DataBase("Stock");
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
    stockList(list);
  }

  void refreshState() {
    _loadStockList();
  }

  void updateStock(Stock stock) {
    stcokDB.updateStock(stock);
  }

  Future removeStock(String stockIndex) {
    return stcokDB.removeStock(stockIndex);
  }
}
