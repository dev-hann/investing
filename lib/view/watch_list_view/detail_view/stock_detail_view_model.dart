import 'package:investing/controller/stock_controller.dart';
import 'package:investing/model/stock.dart';
import 'package:investing/view/view.dart';

class StockDetailViewModel extends ViewModel<StockController> {
  StockDetailViewModel(this.stock);
  final Stock stock;
  bool get isBookmark => controller.watchList.contains(stock);

  Future toggleBookmark() async {
    return controller.toggleFvoriteStock(stock);
  }
}
