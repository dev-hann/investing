import 'package:investing/controller/stock_controller.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/view/stock_view/detail_view/stock_detail_view.dart';
import 'package:investing/widget/book_mark.dart';
import 'package:investing/widget/stock_card.dart';
import 'package:investing/widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StockSearchView extends StatefulWidget {
  const StockSearchView({super.key});

  @override
  State<StockSearchView> createState() => _StockSearchViewState();
}

class _StockSearchViewState extends State<StockSearchView> {
  final controller = StockController.find();
  final queryController = TextEditingController();
  final searchedList = RxList<Stock>();

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
        hintText: "Aa",
      ),
    );
  }

  Widget searchedListWidget({
    required String query,
    required List<Stock> searchedList,
    required List<Stock> favoriteList,
  }) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: searchedList.length,
      itemBuilder: (context, index) {
        final stock = searchedList[index];
        return Card(
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
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 16.0);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: appBar(),
        body: Obx(() {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            physics: const BouncingScrollPhysics(),
            children: [
              queryTextField(
                queryController: queryController,
                onSubmitted: (query) async {
                  if (query.isEmpty) {
                    return;
                  }
                  final list = await controller.searchStock(query);
                  searchedList.clear();
                  searchedList.addAll(list);
                },
              ),
              const SizedBox(height: 16.0),
              searchedListWidget(
                query: queryController.text,
                searchedList: searchedList,
                favoriteList: controller.favoriteList,
              ),
            ],
          );
        }),
      ),
    );
  }
}
