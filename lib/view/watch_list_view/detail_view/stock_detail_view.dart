import 'package:investing/controller/stock_controller.dart';
import 'package:investing/model/stock.dart';
import 'package:investing/view/watch_list_view/detail_view/stock_detail_view_model.dart';
import 'package:investing/view/view.dart';
import 'package:investing/widget/book_mark.dart';
import 'package:flutter/material.dart';
import 'package:investing/widget/chart_button.dart';
import 'package:investing/widget/chart_widget.dart';
import 'package:investing/widget/stock_price_builder.dart';

class StockDetailView extends View<StockDetailViewModel, StockController> {
  StockDetailView({
    super.key,
    required Stock stock,
  }) : super(
          viewModel: StockDetailViewModel(stock),
        );
  AppBar appBar() {
    return AppBar(
      title: const Text("Stock Detail"),
      actions: [
        IconButton(
          onPressed: () {},
          icon: BookMarkWidget(
            onTap: () {
              viewModel.toggleBookmark();
            },
            isBookmark: viewModel.isBookmark,
          ),
        ),
      ],
    );
  }

  Widget titleText(Stock stock) {
    return Builder(builder: (context) {
      final textTheme = Theme.of(context).textTheme;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(stock.name),
          Text(stock.symbol),
          Builder(
            builder: (context) {
              return IVStockPriceBuilder(
                stock: stock,
                lastPriceStyle: textTheme.titleLarge,
                builder: (indicator, percentageChange, netChage, lastPrice) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      lastPrice,
                      Row(
                        children: [
                          indicator,
                          percentageChange,
                          netChage,
                        ],
                      )
                    ],
                  );
                },
              );
            },
          )
        ],
      );
    });
  }

  Widget chartButtonListView() {
    return IVChartButton(
      itemList: [
        ChartButtonItem(text: "1일"),
        ChartButtonItem(text: "1주"),
        ChartButtonItem(text: "1달"),
        ChartButtonItem(text: "3달"),
        ChartButtonItem(text: "1년"),
        ChartButtonItem(text: "전체"),
      ],
    );
  }

  Widget chartWidget(Stock stock) {
    return IVChartWidget(
      stock: stock,
    );
  }

  @override
  Widget body() {
    final stock = viewModel.stock;
    return Scaffold(
      appBar: appBar(),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          titleText(stock),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: chartWidget(stock),
          ),
          chartButtonListView(),
        ],
      ),
    );
  }
}
