import 'package:investing/controller/watch_list_controller.dart';
import 'package:investing/model/stock.dart';
import 'package:investing/view/view.dart';

class WatchListViewModel extends ViewModel<WatchListController> {
  List<Stock> get stockList => controller.watchList;

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
