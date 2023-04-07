library stock_repo;

import 'package:investing/data/db/data_base.dart';
import 'package:investing/data/service/service.dart';
import 'package:investing/model/stock.dart';
import 'package:investing/repo/repo.dart';

part './stock_impl.dart';

abstract class StockRepo extends Repo {
  Stream watchListStream();
  List loadStockList();
  Future updateStock(Stock data);
  Future removeStock(String index);
  Future<List> searchStock(String query);

  Future<List> requestMajorIndexList();
  Future<List> requestFixedIncomeIndexList();
  Future<List> requestCommodityIndexList();
}
