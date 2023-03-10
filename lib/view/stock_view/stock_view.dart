import 'package:dividends_manager/controller/stock_controller.dart';
import 'package:dividends_manager/model/stock.dart';
import 'package:dividends_manager/view/stock_view/stock_view_model.dart';
import 'package:dividends_manager/view/stock_view/widget/stock_card.dart';
import 'package:dividends_manager/view/view.dart';
import 'package:dividends_manager/widget/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StockView extends View<StockViewModel, StockController> {
  StockView({
    super.key,
  }) : super(viewModel: StockViewModel());

  AppBar appBar() {
    return AppBar(
      actions: [
        IconButton(
          onPressed: () {
            final index = DateTime.now().millisecondsSinceEpoch;
            final tmpStock = Stock(
              index: index.toString(),
              name: "TestName$index",
              tickerID: "TextID$index",
            );
            viewModel.updateStock(tmpStock);
          },
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

//  월 평균 배당율
//  월 평균 배당액
//
  Widget monthlyDividendsWidget() {
    return const TitleWidget(
      title: Text("배당 정보"),
      child: Card(
        child: SizedBox(
          height: kToolbarHeight * 2,
          child: Text("@#@#"),
        ),
      ),
    );
  }

  Widget stockListWidget() {
    final list = viewModel.stockList;
    return TitleWidget(
      title: const Text("@@@"),
      child: Obx(() {
        return ReorderableListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (context, index) {
            return Padding(
              key: ValueKey(index),
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: StockCard(
                stock: list[index],
              ),
            );
          },
          onReorder: viewModel.reorder,
        );
      }),
    );
  }

  @override
  Widget body() {
    return Scaffold(
      appBar: appBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 32.0,
        ),
        physics: const BouncingScrollPhysics(),
        children: [
          monthlyDividendsWidget(),
          const SizedBox(height: 16.0),
          stockListWidget(),
        ],
      ),
    );
  }
}
