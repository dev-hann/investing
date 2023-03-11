import 'package:dividends_manager/controller/stock_controller.dart';
import 'package:dividends_manager/view/stock_view/detail_view/stock_detail_view.dart';
import 'package:dividends_manager/view/stock_view/search_view/stock_search_view_model.dart';
import 'package:dividends_manager/view/stock_view/widget/stock_search_card.dart';
import 'package:dividends_manager/view/view.dart';
import 'package:dividends_manager/widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StockSearchView extends View<StockSearchViewModel, StockController> {
  StockSearchView({super.key})
      : super(
          viewModel: StockSearchViewModel(),
        );

  AppBar appBar() {
    return AppBar(
      title: const Text("종목 추가"),
    );
  }

  Widget queryTextField() {
    return Card(
      child: CustomTextfield(
        controller: viewModel.queryCntroller,
        onChanged: viewModel.queryValue,
        onSubmitted: (text) {
          viewModel.searchStock(text);
        },
        hintText: "검색어를 입력해주세요",
      ),
    );
  }

  Widget searchedListWidget() {
    final searchedList = viewModel.searchedList;
    final stockList = viewModel.stockList;
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: searchedList.length,
      itemBuilder: (context, index) {
        final stock = searchedList[index];
        final isBookmark = stockList.contains(stock);
        return StockSearchCard(
          stock: stock,
          onTap: () async {
            Get.to(
              StockDetailView(stock: stock),
            );
          },
          onTapBookmark: () async {
            await viewModel.toggleBookmark(stock);
          },
          isBookmark: isBookmark,
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 16.0);
      },
    );
  }

  @override
  Widget body() {
    return Scaffold(
      appBar: appBar(),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        physics: const BouncingScrollPhysics(),
        children: [
          queryTextField(),
          const SizedBox(height: 16.0),
          searchedListWidget(),
        ],
      ),
    );
  }
}
