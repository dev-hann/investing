import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/controller/stock_search_controller.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/util/navigator.dart';
import 'package:investing/view/stock_view/detail_view/stock_detail_view.dart';
import 'package:investing/widget/book_mark.dart';
import 'package:investing/widget/stock_card.dart';
import 'package:investing/widget/text_field.dart';
import 'package:investing/widget/title_widget.dart';

class StockSearchView extends ConsumerWidget {
  const StockSearchView({super.key});

  AppBar appBar() {
    return AppBar(title: const Text('Search Stock'));
  }

  Widget queryTextField({
    required TextEditingController queryController,
    required void Function(String text) onSubmitted,
  }) {
    return Card(
      child: CustomTextfield(
        controller: queryController,
        textInputAction: TextInputAction.search,
        onSubmitted: onSubmitted,
        autoFocus: true,
        hintText: 'Aa',
      ),
    );
  }

  Widget searchedListWidget({
    required BuildContext context,
    required String query,
    required List<Stock>? searchList,
  }) {
    if (searchList == null) {
      return const Text('init View');
    }
    if (searchList.isEmpty) {
      return const Text('Result Empty View');
    }
    return Column(
      children: searchList.map((stock) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Card(
            child: StockCard(
              stock: stock,
              highlight: query,
              trailing: BookMarkWidget(stock: stock),
              onTap: () {
                unawaited(pushView(context, StockDetailView(stock: stock)));
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(stockSearchControllerProvider.notifier);
    final searchList = ref.watch(stockSearchControllerProvider);
    final queryController = controller.queryController;
    return GestureDetector(
      onTap: () {
        primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: appBar(),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          physics: const BouncingScrollPhysics(),
          children: [
            queryTextField(
              queryController: queryController,
              onSubmitted: (query) {
                if (query.isEmpty) {
                  return;
                }
                unawaited(controller.searchStock(query));
              },
            ),
            const SizedBox(height: 16.0),
            TitleWidget(
              title: const Text('Result'),
              child: searchedListWidget(
                context: context,
                query: queryController.text,
                searchList: searchList,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
