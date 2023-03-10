import 'package:dividends_manager/controller/stock_controller.dart';
import 'package:dividends_manager/view/stock_view/stock_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put<StockController>(StockController());
    return Scaffold(
      body: PageView(
        children: [
          StockView(),
        ],
      ),
    );
  }
}
