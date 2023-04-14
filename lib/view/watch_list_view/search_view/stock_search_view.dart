import 'package:investing/controller/stock_controller.dart';
import 'package:investing/view/watch_list_view/detail_view/stock_detail_view.dart';
import 'package:investing/view/watch_list_view/search_view/stock_search_view_model.dart';
import 'package:investing/widget/stock_search_card.dart';
import 'package:investing/view/view.dart';
import 'package:investing/widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StockSearchView extends View<StockSearchViewModel, StockController> {
  StockSearchView({super.key})
      : super(
          viewModel: StockSearchViewModel(),
        );

  AppBar appBar() {
    return AppBar(
      title: const Text("Search Stock"),
    );
  }

  Widget queryTextField() {
    return Card(
      child: CustomTextfield(
        controller: viewModel.queryCntroller,
        onChanged: viewModel.rxQuery,
        onSubmitted: (text) {
          viewModel.searchStock(text);
        },
        hintText: "Aa",
      ),
    );
  }

  Widget searchedListWidget() {
    final searchedList = viewModel.searchedList;
    final stockList = viewModel.favoriteStockList;
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: searchedList.length,
      itemBuilder: (context, index) {
        final stock = searchedList[index];
        final isBookmark = stockList.contains(stock);
        return StockSearchCard(
          stock: stock,
          query: viewModel.rxQuery.value,
          onTap: () async {
            Get.to(
              StockDetailView(stock: stock),
            );
          },
          onTapBookmark: () async {
            await viewModel.toggleBookmark(stock);
          },
          isBookmakred: isBookmark,
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 16.0);
      },
    );
  }

  @override
  Widget body() {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
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
      ),
    );
  }
}
