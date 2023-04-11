library stock_repo;

import 'package:investing/data/db/data_base.dart';
import 'package:investing/data/db/data_base_model_mixin.dart';
import 'package:investing/data/service/service.dart';
import 'package:investing/repo/repo.dart';

part './stock_impl.dart';

abstract class StockRepo extends Repo {
  Stream watchListStream();
  List loadStockList();
  Future updateStock<T extends DataBaseModelMixin>(T data);
  Future removeStock(String index);
  Future<List> searchStock(String query);

  Future<dynamic> requestIndex({
    required String symbol,
    required String assetClass,
    required String? fromDate,
    required String? toDate,
  });

  // MajorIndex

  Future<dynamic> requestDowIndex({
    required String? fromDate,
    required String? toDate,
  });
  Future<dynamic> requestNasdaqIndex({
    required String? fromDate,
    required String? toDate,
  });
  Future<dynamic> requestSnpIndex({
    required String? fromDate,
    required String? toDate,
  });

  // Treasury
  Future<dynamic> request2YTreasury({
    required String fromDate,
    required String toDate,
  });
  Future<dynamic> request20YTreasury({
    required String fromDate,
    required String toDate,
  });

  // Commodity
  Future<dynamic> requestCrudeOil({
    required String fromDate,
    required String toDate,
  });
  Future<dynamic> requestGold({
    required String fromDate,
    required String toDate,
  });
  Future<dynamic> requestCopper({
    required String fromDate,
    required String toDate,
  });
  Future<dynamic> requestNaturalGas({
    required String fromDate,
    required String toDate,
  });
}
