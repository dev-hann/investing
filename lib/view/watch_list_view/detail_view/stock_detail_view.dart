import 'package:investing/controller/watch_list_controller.dart';
import 'package:investing/model/stock.dart';
import 'package:investing/view/watch_list_view/detail_view/stock_detail_view_model.dart';
import 'package:investing/view/view.dart';
import 'package:investing/widget/book_mark.dart';
import 'package:flutter/material.dart';

class StockDetailView extends View<StockDetailViewModel, WatchListController> {
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
