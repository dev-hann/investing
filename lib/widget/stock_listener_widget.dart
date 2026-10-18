import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/controller/stock_controller.dart';
import 'package:investing/model/stock/stock.dart';

/// Rebuilds [child] whenever the stock state changes.
class StockListenerWidget extends ConsumerWidget {
  const StockListenerWidget({
    super.key,
    required this.stock,
    required this.child,
  });
  final Stock stock;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(stockControllerProvider);
    return child;
  }
}
