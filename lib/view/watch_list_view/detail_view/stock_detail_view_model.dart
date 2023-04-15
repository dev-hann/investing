import 'package:investing/controller/stock_controller.dart';
import 'package:investing/model/stock.dart';
import 'package:investing/view/view.dart';

class StockDetailViewModel extends ViewModel<StockController> {
  StockDetailViewModel(this.stock);
  Stock stock;
  bool get isBookmark => controller.contains(stock);

  @override
  Future init() async {
    stock = await controller.requestStockWithChart(stock);
    return super.init();
  }

  Future toggleBookmark() async {
    if (controller.contains(stock)) {
      return controller.removeFavoriteStock(stock);
    }
    return controller.updateFavoriteStock(stock);
  }
}
