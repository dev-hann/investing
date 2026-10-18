import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/controller/stock_controller.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/model/stock/stock_company.dart';
import 'package:investing/widget/title_widget.dart';

class CompanyView extends ConsumerStatefulWidget {
  const CompanyView({super.key, required this.stock});
  final Stock stock;

  @override
  ConsumerState<CompanyView> createState() => _CompanyViewState();
}

class _CompanyViewState extends ConsumerState<CompanyView> {
  StockCompany? company;

  @override
  void initState() {
    super.initState();
    unawaited(_requestCompany());
  }

  Future<void> _requestCompany() async {
    final res = await ref
        .read(stockControllerProvider.notifier)
        .reqeustStockCompany(widget.stock);
    if (mounted) {
      setState(() {
        company = res;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final companyValue = company;
    if (companyValue == null) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TitleWidget(
        title: const Text('Company Profile'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text(companyValue.description)],
        ),
      ),
    );
  }
}
