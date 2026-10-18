import 'dart:async';

import 'package:flutter/material.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/widget/alert.dart';
import 'package:investing/widget/stock_card.dart';

class EditView extends StatelessWidget {
  EditView({super.key, required List<Stock> itemList})
    : itemListNotifier = ValueNotifier(itemList);
  final ValueNotifier<List<Stock>> itemListNotifier;

  Future<void> deleteItem({
    required BuildContext context,
    required int index,
    required List<Stock> itemList,
  }) async {
    final navigator = Navigator.of(context);
    final res = await showDialog<bool>(
      context: context,
      builder: (context) {
        return IVAlert(
          content: const Text('Delete?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                navigator.pop(true);
              },
              child: const Text('Delete'),
            ),
            ElevatedButton(
              onPressed: () {
                navigator.pop(false);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
    if (res == true) {
      final list = [...itemList]..removeAt(index);
      itemListNotifier.value = list;
    }
  }

  void reorderList({
    required int oldIndex,
    required int index,
    required List<Stock> itemList,
  }) {
    final list = [...itemList];
    final row = list.removeAt(oldIndex);
    list.insert(index, row);
    itemListNotifier.value = list;
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: const Text('Stock Edit View'),
      leading: IconButton(
        onPressed: () {
          final itemList = itemListNotifier.value;
          final List<Stock> res = [];
          for (int index = 0; index < itemList.length; ++index) {
            final item = itemList[index];
            res.add(item.copyWith(order: index));
          }
          Navigator.of(context).pop(res);
        },
        icon: const Icon(Icons.arrow_back),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: ValueListenableBuilder<List<Stock>>(
        valueListenable: itemListNotifier,
        builder: (context, itemList, _) {
          return ReorderableListView.builder(
            onReorderItem: (oldIndex, index) {
              reorderList(oldIndex: oldIndex, index: index, itemList: itemList);
            },
            padding: const EdgeInsets.all(16.0),
            itemCount: itemList.length,
            itemBuilder: (context, index) {
              final item = itemList[index];
              return Padding(
                key: ValueKey(index),
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Card(
                  child: StockCard(
                    stock: item,
                    leading: ReorderableDragStartListener(
                      index: index,
                      child: const Icon(Icons.reorder),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        unawaited(
                          deleteItem(
                            context: context,
                            index: index,
                            itemList: itemList,
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
