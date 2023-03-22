import 'package:investing/controller/watch_list_controller.dart';
import 'package:investing/model/stock.dart';
import 'package:investing/view/view.dart';

class StockDetailViewModel extends ViewModel<WatchListController> {
  StockDetailViewModel(this.stock);
  final Stock stock;
  bool get isBookmark => controller.watchList.contains(stock);

  Future toggleBookmark() {
    return controller.toggleBookmark(stock);
  }
}
