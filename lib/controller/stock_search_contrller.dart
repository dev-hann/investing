import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investing/controller/controller.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/use_case/stock_use_case.dart';

class StockSearchController extends Controller<StockUseCase> {
  StockSearchController(super.useCase);
  static StockSearchController find() => Get.find();
  final TextEditingController queryController = TextEditingController();
  List<Stock>? searchList;

  Future searchStock(String query) async {
    searchList = null;

    searchList = await useCase.searchStock(query);
    update();
  }
}
