import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investing/controller/stock_controller.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/model/stock/stock_financial.dart';
import 'package:investing/widget/title_widget.dart';

class FinancialView extends StatefulWidget {
  const FinancialView({super.key, required this.stock});
  final Stock stock;

  @override
  State<FinancialView> createState() => _FinancialViewState();
}

class _FinancialViewState extends State<FinancialView> {
  final StockController controller = StockController.find();

  final Rxn<StockFinancial> financial = Rxn();

  @override
  void initState() {
    super.initState();
    controller
        .requestStockFinancial(
          stock: widget.stock,
          type: FinancialType.annual,
        )
        .then(financial);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final financialValue = financial.value;
      if (financialValue == null) {
        return const SizedBox();
      }
      return TitleWidget(
        title: const Text("Financial"),
        child: Text(
          financialValue.balanceTable.toString(),
        ),
      );
    });
  }
}
