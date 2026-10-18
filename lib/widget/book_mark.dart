import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/controller/stock_controller.dart';
import 'package:investing/model/stock/stock.dart';

class BookMarkWidget extends ConsumerWidget {
  const BookMarkWidget({
    super.key,
    required this.stock,
    this.activeColor = Colors.orangeAccent,
    this.color = Colors.white,
  });
  final Stock stock;
  final Color activeColor;
  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(stockControllerProvider);
    final isContains = ref
        .read(stockControllerProvider.notifier)
        .isContains(stock);
    return GestureDetector(
      onTap: () {
        unawaited(
          ref.read(stockControllerProvider.notifier).toggleFavoriteStock(stock),
        );
      },
      child: Icon(
        isContains ? Icons.bookmark : Icons.bookmark_border,
        color: isContains ? activeColor : color,
      ),
    );
  }
}
