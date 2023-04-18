import 'package:investing/controller/stock_controller.dart';
import 'package:investing/model/stock.dart';
import 'package:investing/model/stock_detail.dart';
import 'package:investing/view/view.dart';

class StockDetailViewModel extends ViewModel<StockController> {
  StockDetailViewModel(this.stock);
  final Stock stock;
  late StockDetail stockDetail;
  bool get isBookmark => controller.contains(stock);

  @override
  Future init() async {
    final detail = StockDetail.fromStock(stock);
    stockDetail = await controller.requestStockDetail(detail);
    return super.init();
  }

  Future toggleBookmark() async {
    if (controller.contains(stock)) {
      return controller.removeFavoriteStock(stock);
    }
    return controller.updateFavoriteStock(stock);
  }
}
