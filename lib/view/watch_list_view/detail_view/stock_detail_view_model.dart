import 'package:dividends_manager/controller/watch_list_controller.dart';
import 'package:dividends_manager/model/stock.dart';
import 'package:dividends_manager/view/view.dart';

class StockDetailViewModel extends ViewModel<WatchListController> {
  StockDetailViewModel(this.stock);
  final Stock stock;
  bool get isBookmark => controller.watchList.contains(stock);

  Future toggleBookmark() {
    return controller.toggleBookmark(stock);
  }
}
