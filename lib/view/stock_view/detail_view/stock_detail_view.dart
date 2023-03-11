import 'package:dividends_manager/controller/stock_controller.dart';
import 'package:dividends_manager/model/stock.dart';
import 'package:dividends_manager/view/stock_view/detail_view/stock_detail_view_model.dart';
import 'package:dividends_manager/view/view.dart';
import 'package:dividends_manager/widget/book_mark.dart';
import 'package:flutter/material.dart';

class StockDetailView extends View<StockDetailViewModel, StockController> {
  StockDetailView({super.key, required Stock stock})
      : super(
          viewModel: StockDetailViewModel(stock),
        );
  AppBar appBar() {
    return AppBar(
      title: const Text("상세 정보"),
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
