import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investing/controller/stock_controller.dart';
import 'package:investing/model/stock/stock_company.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/widget/title_widget.dart';

class CompanyView extends StatefulWidget {
  const CompanyView({
    super.key,
    required this.stock,
  });
  final Stock stock;

  @override
  State<CompanyView> createState() => _CompanyViewState();
}

class _CompanyViewState extends State<CompanyView> {
  final StockController controller = StockController.find();
  final Rxn<StockCompany> company = Rxn();

  @override
  void initState() {
    super.initState();
    controller.reqeustStockCompany(widget.stock).then(company);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final companyValue = company.value;
      if (companyValue == null) {
        return const SizedBox();
      }
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TitleWidget(
          title: const Text("Company Profile"),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(companyValue.description),
            ],
          ),
        ),
      );
    });
  }
}
