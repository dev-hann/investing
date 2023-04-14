import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investing/controller/stock_controller.dart';
import 'package:investing/model/stock.dart';

class StockListenerWidget extends StatelessWidget {
  const StockListenerWidget({
    super.key,
    required this.stock,
    required this.child,
  });
  final Stock stock;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StockController>(
      id: stock.symbol,
      builder: (controller) {
        return child;
      },
    );
  }
}
