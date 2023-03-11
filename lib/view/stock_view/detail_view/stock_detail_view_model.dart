import 'package:dividends_manager/controller/stock_controller.dart';
import 'package:dividends_manager/model/stock.dart';
import 'package:dividends_manager/view/view.dart';

class StockDetailViewModel extends ViewModel<StockController> {
  StockDetailViewModel(this.stock);
  final Stock stock;
  bool get isBookmark => controller.stockList.contains(stock);

  Future toggleBookmark() {
    return controller.toggleBookmark(stock);
  }
}
