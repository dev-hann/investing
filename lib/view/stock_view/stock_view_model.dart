import 'package:dividends_manager/controller/stock_controller.dart';
import 'package:dividends_manager/model/stock.dart';
import 'package:dividends_manager/view/view.dart';

class StockViewModel extends ViewModel<StockController> {
  List<Stock> get stockList => controller.stockList;

  @override
  Future init() async {
    controller.refreshState();
    super.init();
  }

  void updateStock(Stock stock) {
    controller.updateStock(stock);
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    // final list = stockList;
    // final oldItem = list[oldIndex];
    // final oldItemIndex = oldItem.index;
    // await controller.removeStock(oldItemIndex);
    // controller.updateStock(
    //   oldItem.copyWith(
    //     index:list[newIndex].index
    //   ),
    // );
    // return;
  }
  Future removeStock(Stock stock) {
    return controller.removeStock(stock.index);
  }
}
