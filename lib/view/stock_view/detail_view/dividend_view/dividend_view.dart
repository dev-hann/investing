import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investing/controller/stock_controller.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/model/stock/stock_dividend.dart';
import 'package:investing/util/date_time_format.dart';
import 'package:investing/util/number_format.dart';
import 'package:investing/view/stock_view/detail_view/dividend_view/dividend_detail_view.dart';
import 'package:investing/widget/data_row.dart';
import 'package:investing/widget/text_button.dart';
import 'package:investing/widget/title_widget.dart';

class DividendView extends StatefulWidget {
  const DividendView({
    super.key,
    required this.stock,
  });
  final Stock stock;

  @override
  State<DividendView> createState() => _DividendViewState();
}

class _DividendViewState extends State<DividendView> {
  final StockController controller = StockController.find();
  final Rxn<StockDividend> dividend = Rxn();

  @override
  void initState() {
    super.initState();
    controller.requestStockDividend(widget.stock).then(dividend);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final dividendValue = dividend.value;
      if (dividendValue == null) {
        return const SizedBox();
      }
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TitleWidget.withButton(
          title: const Text("Dividend"),
          trailing: IVTextButton.more(
            onTap: () {
              controller.bottomSheet(
                DividendDetailView(dividend: dividendValue),
              );
            },
          ),
          child: Column(
            children: [
              IVDateRow(
                title: const Text("Annual Dividend"),
                data: Text(
                  IVNumberFormat.priceFormat(
                    dividendValue.annualizedDividend,
                  ),
                ),
              ),
              IVDateRow(
                title: const Text("Dividend Ratio"),
                data: Text("${dividendValue.yield.toString()}%"),
              ),
              Builder(
                builder: (context) {
                  final text = IVDateTimeFormat(dividendValue.exDividendDate)
                      .dateTimeFormat();
                  return IVDateRow(
                    title: const Text("Ex Dividend Date"),
                    data: Text(text ?? ""),
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
