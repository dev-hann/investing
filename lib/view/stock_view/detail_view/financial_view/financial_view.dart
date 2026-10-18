import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/controller/stock_controller.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/model/stock/stock_financial.dart';
import 'package:investing/widget/title_widget.dart';

class FinancialView extends ConsumerStatefulWidget {
  const FinancialView({super.key, required this.stock});
  final Stock stock;

  @override
  ConsumerState<FinancialView> createState() => _FinancialViewState();
}

class _FinancialViewState extends ConsumerState<FinancialView> {
  StockFinancial? financial;

  @override
  void initState() {
    super.initState();
    unawaited(_requestFinancial());
  }

  Future<void> _requestFinancial() async {
    final res = await ref
        .read(stockControllerProvider.notifier)
        .requestStockFinancial(stock: widget.stock, type: FinancialType.annual);
    if (mounted) {
      setState(() {
        financial = res;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final financialValue = financial;
    if (financialValue == null) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TitleWidget(
        title: const Text('Financial'),
        child: Text(financialValue.balanceTable.toString()),
      ),
    );
  }
}
