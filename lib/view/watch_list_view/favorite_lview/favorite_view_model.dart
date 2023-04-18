import 'package:investing/controller/stock_controller.dart';
import 'package:investing/model/stock.dart';
import 'package:investing/view/view.dart';

class FavoriteViewModel extends ViewModel<StockController> {
  List<Stock> get favoriteStockList => controller.favoriteStockList;

  void onTapRemoveStock(Stock stock) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return controller.removeFavoriteStock(stock);
  }
}
