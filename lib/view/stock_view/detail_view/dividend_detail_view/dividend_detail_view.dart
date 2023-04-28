import 'package:flutter/material.dart';
import 'package:investing/model/stock/stock_dividend.dart';

class DividendDetailView extends StatelessWidget {
  const DividendDetailView({
    super.key,
    required this.dividend,
  });
  final StockDividend dividend;

  AppBar appBar() {
    return AppBar(
      title: const Text("Dividend Detail View"),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = dividend.histoyList;
    return Scaffold(
      appBar: appBar(),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          final item = list[index];
          return Text(
            item.toString(),
          );
        },
      ),
    );
  }
}
