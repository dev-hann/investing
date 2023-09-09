import 'package:investing/controller/stock_search_contrller.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/view/stock_view/detail_view/stock_detail_view.dart';
import 'package:investing/widget/book_mark.dart';
import 'package:investing/widget/stock_card.dart';
import 'package:investing/widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investing/widget/title_widget.dart';

class StockSearchView extends StatelessWidget {
  const StockSearchView({super.key});

  AppBar appBar() {
    return AppBar(
      title: const Text("Search Stock"),
    );
  }

  Widget queryTextField({
    required TextEditingController queryController,
    required Function(String text) onSubmitted,
  }) {
    return Card(
      child: CustomTextfield(
        controller: queryController,
        textInputAction: TextInputAction.search,
        onSubmitted: onSubmitted,
        autoFocus: true,
        hintText: "Aa",
      ),
    );
  }

  Widget searchedListWidget({
    required String query,
    required List<Stock>? searchList,
  }) {
    if (searchList == null) {
      return const Text("init View");
    }
    if (searchList.isEmpty) {
      return const Text("Result Empty View");
    }
    return Column(
      children: searchList.map((stock) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Card(
            child: StockCard(
              stock: stock,
              highlight: query,
              trailing: BookMarkWidget(
                stock: stock,
              ),
              onTap: () {
                Get.to(
                  StockDetailView(stock: stock),
                );
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: appBar(),
        body: GetBuilder<StockSearchController>(
          builder: (controller) {
            final searchList = controller.searchList;
            final queryController = controller.queryController;
            return ListView(
              padding: const EdgeInsets.all(16.0),
              physics: const BouncingScrollPhysics(),
              children: [
                queryTextField(
                  queryController: queryController,
                  onSubmitted: (query) {
                    if (query.isEmpty) {
                      return;
                    }
                    controller.searchStock(query);
                  },
                ),
                const SizedBox(height: 16.0),
                TitleWidget(
                  title: const Text("Result"),
                  child: searchedListWidget(
                    query: queryController.text,
                    searchList: searchList,
                    //  controller.favoriteList,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
