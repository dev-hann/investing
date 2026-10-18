import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/controller/stock_controller.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/model/stock/stock_dividend.dart';
import 'package:investing/util/date_time_format.dart';
import 'package:investing/util/number_format.dart';
import 'package:investing/view/stock_view/detail_view/dividend_view/dividend_detail_view.dart';
import 'package:investing/widget/data_row.dart';
import 'package:investing/widget/text_button.dart';
import 'package:investing/widget/title_widget.dart';

class DividendView extends ConsumerStatefulWidget {
  const DividendView({super.key, required this.stock});
  final Stock stock;

  @override
  ConsumerState<DividendView> createState() => _DividendViewState();
}

class _DividendViewState extends ConsumerState<DividendView> {
  StockDividend? dividend;

  @override
  void initState() {
    super.initState();
    unawaited(_requestDividend());
  }

  Future<void> _requestDividend() async {
    final res = await ref
        .read(stockControllerProvider.notifier)
        .requestStockDividend(widget.stock);
    if (mounted) {
      setState(() {
        dividend = res;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dividendValue = dividend;
    if (dividendValue == null) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TitleWidget.withButton(
        title: const Text('Dividend'),
        trailing: IVTextButton.more(
          onTap: () {
            unawaited(
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return DividendDetailView(dividend: dividendValue);
                },
              ),
            );
          },
        ),
        child: Column(
          children: [
            IVDateRow(
              title: const Text('Annual Dividend'),
              data: Text(
                IVNumberFormat.priceFormat(dividendValue.annualizedDividend),
              ),
            ),
            IVDateRow(
              title: const Text('Dividend Ratio'),
              data: Text('${dividendValue.yield.toString()}%'),
            ),
            Builder(
              builder: (context) {
                final text = IVDateTimeFormat(dividendValue.exDividendDate)
                    .dateTimeFormat();
                return IVDateRow(
                  title: const Text('Ex Dividend Date'),
                  data: Text(text ?? ''),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
