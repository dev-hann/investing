import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/use_case/stock_use_case.dart';

class StockSearchController extends Notifier<List<Stock>?> {
  final TextEditingController queryController = TextEditingController();

  @override
  List<Stock>? build() {
    ref.onDispose(queryController.dispose);
    return null;
  }

  Future<void> searchStock(String query) async {
    final useCase = ref.read(stockUseCaseProvider);
    state = await useCase.searchStock(query);
  }
}

final stockSearchControllerProvider =
    NotifierProvider<StockSearchController, List<Stock>?>(
      StockSearchController.new,
    );
