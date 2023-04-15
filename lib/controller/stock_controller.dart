import 'package:hive_flutter/hive_flutter.dart';
import 'package:investing/controller/controller.dart';
import 'package:get/get.dart';
import 'package:investing/model/stock.dart';
import 'package:investing/use_case/stock_use_case.dart';

class StockController extends Controller<StockUseCase> {
  StockController(super.useCase);

  static StockController find() => Get.find<StockController>();
  final List<Stock> favoriteStockList = [];

  Stream<BoxEvent> get watchListStream => useCase.watchListStream();

  @override
  Future onReady() async {
    _initFavoriteStockList();
    super.onReady();
  }

  void _initFavoriteStockList() {
    watchListStream.listen((event) {
      refreshWatchList(event);
    });
    favoriteStockList.addAll(useCase.loadStockList());
    for (int index = 0; index < favoriteStockList.length; ++index) {
      final stock = favoriteStockList[index];
      useCase
          .requestStockWithChart(
        stock: stock,
        dateTimeRange: stock.dateTimeRangeList.first,
      )
          .then((value) async {
        favoriteStockList[index] = value;
        // TODO: update veiew by id
        update();
      });
    }
  }

  void refreshWatchList(BoxEvent event) async {
    final index =
        favoriteStockList.indexWhere((element) => element.symbol == event.key);
    final isDeleted = event.deleted;
    if (isDeleted) {
      favoriteStockList.removeAt(index);
    } else {
      final stock = Stock.fromDB(event.value);
      final isNew = index == -1;
      if (isNew) {
        favoriteStockList.add(stock);
      } else {
        final res = await useCase.requestStockWithChart(
          stock: stock,
          dateTimeRange: stock.dateTimeRangeList.first,
        );
        favoriteStockList[index] = res;
      }
    }
    update();
  }

  List<Stock> loadStockList() {
    return useCase.loadStockList();
  }

  Future updateFavoriteStock(Stock stock) {
    return useCase.updateStock(stock);
  }

  Future removeFavoriteStock(Stock stock) {
    return useCase.removeStock(stock.index);
  }

  Future<List<Stock>> searchStock(String query) async {
    return useCase.searchStock(query);
  }

  Future<Stock> requestStockWithChart(Stock stock) {
    return useCase.requestStockWithChart(
      stock: stock,
      dateTimeRange: stock.dateTimeRangeList.first,
    );
  }

  bool contains(Stock stock) {
    return favoriteStockList.contains(stock);
  }
}
