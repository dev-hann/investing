import 'package:investing/controller/controller.dart';
import 'package:investing/model/index.dart';
import 'package:investing/model/stock.dart';
import 'package:get/get.dart';
import 'package:investing/use_case/stock_use_case.dart';

class StockController extends Controller<StockUseCase> {
  StockController(super.useCase);

  static StockController find() => Get.find<StockController>();

  final List<Index> indexList = <Index>[];
  final List<Stock> watchList = <Stock>[];

  Stream get watchListStream => useCase.watchListStream();

  @override
  Future onReady() async {
    watchListStream.listen((event) {
      refreshState();
    });
    indexList.clear();
    for (final type in IndexType.values) {
      final index = await useCase.requestIndex(type);
      indexList.add(index);
    }
    refreshState();
    super.onReady();
  }

  void refreshState() {
    final list = useCase.loadStockList();
    watchList.clear();
    watchList.addAll(list);
    update();
  }

  Future updateFavoriteStock(Stock stock) {
    return useCase.updateStock(stock);
  }

  Future removeFavoriteStock(String stockIndex) {
    return useCase.removeStock(stockIndex);
  }

  Future toggleFvoriteStock(Stock stock) async {
    if (watchList.contains(stock)) {
      await removeFavoriteStock(stock.index);
    } else {
      await updateFavoriteStock(stock);
    }
  }

  Future<List<Stock>> searchStock(String query) async {
    return useCase.searchStock(query);
  }
}
