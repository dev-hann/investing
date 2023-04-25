import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/widget/alert.dart';
import 'package:investing/widget/stock_card.dart';

class EditView extends StatelessWidget {
  EditView({
    super.key,
    required List<Stock> itemList,
  }) : itemListNotifier = ValueNotifier(itemList);
  final ValueNotifier<List<Stock>> itemListNotifier;

  void deleteItem({
    required int index,
    required List<Stock> itemList,
  }) async {
    final res = await Get.dialog(
      IVAlert(
        content: const Text("Delete?"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back(result: true);
            },
            child: const Text("Delete"),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(result: false);
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
    if (res != null && res) {
      final list = [...itemList];
      list.removeAt(index);
      itemListNotifier.value = list;
    }
  }

  void reorderList({
    required int oldIndex,
    required int index,
    required List<Stock> itemList,
  }) {
    final list = [...itemList];
    int newIndex = index;
    if (oldIndex < index) {
      newIndex = index - 1;
    }
    final row = list.removeAt(oldIndex);
    list.insert(newIndex, row);
    itemListNotifier.value = list;
  }

  AppBar appBar() {
    return AppBar(
      title: const Text("Stock Edit View"),
      leading: IconButton(
        onPressed: () {
          final itemList = itemListNotifier.value;
          final List<Stock> res = [];
          for (int index = 0; index < itemList.length; ++index) {
            final item = itemList[index];
            res.add(
              item.copyWith(order: index),
            );
          }
          Get.back(result: res);
        },
        icon: const Icon(Icons.arrow_back),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: ValueListenableBuilder<List<Stock>>(
          valueListenable: itemListNotifier,
          builder: (context, itemList, _) {
            return ReorderableListView.builder(
              onReorder: (oldIndex, index) {
                reorderList(
                  oldIndex: oldIndex,
                  index: index,
                  itemList: itemList,
                );
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
                        onPressed: () async {
                          deleteItem(
                            index: index,
                            itemList: itemList,
                          );
                        },
                        icon: const Icon(
                          Icons.delete,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
