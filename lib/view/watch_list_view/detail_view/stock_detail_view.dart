import 'package:investing/controller/stock_controller.dart';
import 'package:investing/model/ticker.dart';
import 'package:investing/view/watch_list_view/detail_view/stock_detail_view_model.dart';
import 'package:investing/view/view.dart';
import 'package:investing/widget/book_mark.dart';
import 'package:flutter/material.dart';

class StockDetailView extends View<StockDetailViewModel, StockController> {
  StockDetailView({
    super.key,
    required Ticker stock,
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

  @override
  Widget body() {
    return Scaffold(
      appBar: appBar(),
    );
  }
}
