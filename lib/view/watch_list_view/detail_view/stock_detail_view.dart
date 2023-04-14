import 'package:investing/controller/stock_controller.dart';
import 'package:investing/model/stock.dart';
import 'package:investing/view/watch_list_view/detail_view/stock_detail_view_model.dart';
import 'package:investing/view/view.dart';
import 'package:investing/widget/book_mark.dart';
import 'package:flutter/material.dart';
import 'package:investing/widget/chart_widget.dart';
import 'package:investing/widget/stock_price_text.dart';

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

  Widget title(Stock stock) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(stock.name),
        Text(stock.symbol),
        Text(stock.lastSalePrice),
        IVStockPriceText(stock: stock)
      ],
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
          title(stock),
          IVChartWidget(
            stock: stock,
          )
        ],
      ),
    );
  }
}
