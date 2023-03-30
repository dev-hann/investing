import 'package:investing/controller/stock_controller.dart';
import 'package:investing/model/stock.dart';
import 'package:investing/view/view.dart';

class FavoriteViewModel extends ViewModel<StockController> {
  List<Stock> get stockList => controller.watchList;

  Future removeStock(Stock stock) {
    return controller.removeStock(stock.index);
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
}
