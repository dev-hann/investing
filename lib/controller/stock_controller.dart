import 'package:investing/controller/controller.dart';
import 'package:investing/model/index.dart';
import 'package:investing/model/ticker.dart';
import 'package:get/get.dart';
import 'package:investing/use_case/stock_use_case.dart';

class StockController extends Controller<StockUseCase> {
  StockController(super.useCase);

  static StockController find() => Get.find<StockController>();

  final List<Index> indexList = <Index>[
    Index.nasdaq(),
    Index.snp(),
    Index.dow(),
    Index.treasury2Y(),
    Index.treasury20Y(),
    Index.gold(),
    Index.copper(),
    Index.naturalGas(),
    Index.crudeOil(),
  ];
  final List<Ticker> watchList = <Ticker>[];

  Stream get watchListStream => useCase.watchListStream();

  @override
  Future onReady() async {
    watchListStream.listen((event) {
      refreshState();
    });
    for (int index = 0; index < indexList.length; ++index) {
      final item = indexList[index];
      final res = await useCase.requestIndex(
        index: item,
        dateTimeRange: item.dateTimeRangeList.first,
      );
      print(res);
      indexList[index] = res;
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

  Future updateFavoriteStock(Ticker stock) {
    return useCase.updateStock(stock);
  }

  Future removeFavoriteStock(String stockIndex) {
    return useCase.removeStock(stockIndex);
  }

  Future toggleFvoriteStock(Ticker stock) async {
    if (watchList.contains(stock)) {
      await removeFavoriteStock(stock.index);
    } else {
      await updateFavoriteStock(stock);
    }
  }

  Future<List<Ticker>> searchStock(String query) async {
    return useCase.searchStock(query);
  }
}
