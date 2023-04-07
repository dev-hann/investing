import 'package:investing/controller/controller.dart';
import 'package:investing/model/index.dart';
import 'package:investing/model/stock.dart';
import 'package:get/get.dart';
import 'package:investing/repo/stock/stock_repo.dart';

class StockController extends Controller<StockRepo> {
  StockController(super.repo);

  static StockController find() => Get.find<StockController>();

  final List<Index> indexList = <Index>[];
  final List<Stock> watchList = <Stock>[];

  Stream get watchListStream => repo.watchListStream();

  @override
  Future onReady() async {
    watchListStream.listen((event) {
      refreshState();
    });
    indexList.addAll(await requestMajorIndexList());
    refreshState();
    super.onReady();
  }

  void refreshState() {
    final list = repo.loadStockList().map((e) => Stock.fromMap(e)).toList();
    list.sort();
    watchList.clear();
    watchList.addAll(list);
    update();
  }

  Future updateStock(Stock stock) {
    return repo.updateStock(stock);
  }

  Future removeStock(String stockIndex) {
    return repo.removeStock(stockIndex);
  }

  Future toggleBookmark(Stock stock) async {
    if (watchList.contains(stock)) {
      await removeStock(stock.index);
    } else {
      await updateStock(stock);
    }
  }

  Future<List<Stock>> searchStock(String query) async {
    final list = await repo.searchStock(query);
    final searchedList = <Stock>[];
    for (int index = 0; index < list.length; ++index) {
      final item = Stock.dto(list[index]);
      if (!searchedList.contains(item)) {
        searchedList.add(item);
      }
    }
    return searchedList;
  }

  Future<List<Index>> requestMajorIndexList() async {
    final res = await repo.requestMajorIndexList();
    final list = List.from(res).map((e) => Index.majorIndex(e)).toList();
    return list;
  }
}
