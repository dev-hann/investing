import 'package:investing/controller/stock_controller.dart';
import 'package:investing/model/stock.dart';
import 'package:investing/model/stock_detail.dart';
import 'package:investing/view/view.dart';

class IndexViewModel extends ViewModel<StockController> {
  final List<Stock> _indexStockList = [
    Stock.nasdaq(),
    Stock.snp(),
    Stock.dow(),
    Stock.treasury2Y(),
    Stock.treasury20Y(),
    Stock.gold(),
    Stock.copper(),
    Stock.naturalGas(),
    Stock.crudeOil(),
  ];
  final List<StockDetail> indexDetailList = [];

  @override
  Future init() async {
    await refreshIndexList();
    return super.init();
  }

  Future refreshIndexList() async {
    indexDetailList.clear();
    for (int index = 0; index < _indexStockList.length; ++index) {
      final stock = _indexStockList[index];
      final res = await controller.requestStockDetail(
        StockDetail.fromStock(stock),
      );
      indexDetailList.add(res);
    }
    updateView();
  }
}
