import 'package:dividends_manager/controller/stock_controller.dart';
import 'package:dividends_manager/view/stock_view/detail_view/stock_detail_view.dart';
import 'package:dividends_manager/view/stock_view/search_view/stock_search_view.dart';
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
      title: const Text("배당 관리"),
    );
  }

//  월 평균 배당율
//  월 평균 배당액
  Widget monthlyDividendsWidget() {
    return const TitleWidget(
      title: Text("배당 정보"),
      child: Card(
        child: SizedBox(
          height: kToolbarHeight * 2,
          child: Center(
            child: Text("@#@#"),
          ),
        ),
      ),
    );
  }

  Widget stockListWidget() {
    final list = viewModel.stockList;
    return TitleWidget(
      title: Row(
        children: [
          const Expanded(child: Text("종목")),
          GestureDetector(
            onTap: () {
              Get.to(
                StockSearchView(),
              );
              // final index = int.parse(
              //   DateTime.now().millisecondsSinceEpoch.toString().substring(10),
              // );
              // final tmpStock = Stock(
              //   index: index.toString(),
              //   stockTypeIndex: StockType.values[index % 2].index,
              //   name: "TestName$index",
              //   tickerID: "ID$index",
              //   count: index * 12,
              //   price: index * 23,
              //   dividendYield: index / 2,
              // );
              // viewModel.updateStock(tmpStock);
            },
            child: Row(
              children: const [
                Text(
                  "종목 추가",
                  style: TextStyle(
                    color: Colors.orangeAccent,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 8.0,
                  color: Colors.orangeAccent,
                )
              ],
            ),
          ),
        ],
      ),
      child: ReorderableListView.builder(
        reverse: true,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          final stock = list[index];
          return Padding(
            key: ValueKey(index),
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: StockCard(
              stock: stock,
              onTap: () {
                Get.to(
                  StockDetailView(stock: stock),
                );
              },
              onTapRemove: () {
                viewModel.removeStock(stock);
              },
            ),
          );
        },
        onReorder: viewModel.reorder,
      ),
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
