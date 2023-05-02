import 'package:flutter/material.dart';
import 'package:investing/model/stock/stock_dividend.dart';
import 'package:investing/util/date_time_format.dart';
import 'package:investing/util/number_format.dart';
import 'package:investing/widget/data_row.dart';

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

  Widget dateRow({
    required List<Widget> valueList,
    TextStyle? style,
  }) {
    return DefaultTextStyle(
      style: style ?? const TextStyle(),
      child: Row(
        children:
            valueList.map((e) => Expanded(child: Center(child: e))).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = dividend.histoyList;
    return Scaffold(
      appBar: appBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            dateRow(
              style: Theme.of(context).textTheme.titleMedium,
              valueList: const [
                Text("Ex Dividend Day", maxLines: 1),
                Text("Pay Day", maxLines: 1),
                Text("Yield", maxLines: 1),
              ],
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return const Divider();
                },
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final item = list[index];
                  final declarationText =
                      IVDateTimeFormat(item.exOrEffDate).dateTimeFormat() ?? "";
                  final paymentText =
                      IVDateTimeFormat(item.paymentDate).dateTimeFormat() ?? "";
                  return dateRow(
                    valueList: [
                      Text(declarationText),
                      Text(paymentText),
                      Text(IVNumberFormat.priceFormat(item.amount)),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
