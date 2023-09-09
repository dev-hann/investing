import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:investing/const/color.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/util/number_format.dart';
import 'package:investing/widget/shimmer.dart';
import 'package:investing/widget/stock_card.dart';
import 'package:investing/widget/stock_price_builder.dart';
import 'package:investing/widget/title_widget.dart';

// TODO: (Future Work)  make Favorite Directory
class FavoriteView extends StatelessWidget {
  const FavoriteView({
    super.key,
    required this.favoriteList,
    required this.onTapStock,
    required this.onTapEdit,
    required this.onTapRemove,
  });
  final List<Stock>? favoriteList;
  final Function(Stock stock) onTapStock;
  final VoidCallback onTapEdit;
  final Function(Stock stock) onTapRemove;

  Widget loadingWidget() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (context, index) {
        return const SizedBox(height: 8.0);
      },
      itemCount: 100,
      itemBuilder: (context, index) {
        return IVShimmer.listTile();
      },
    );
  }

  Widget emptyWidget() {
    return SizedBox(
      height: Get.height / 3,
      child: const Center(
        child: Text("Favorite List is Empty!"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TitleWidget(
        title: Row(
          children: [
            const Expanded(child: Text("Favorites")),
            GestureDetector(
              onTap: onTapEdit,
              //  () async {
              //   // final list = await Get.to(
              //   //   EditView(
              //   //     itemList: stockController.favoriteList,
              //   //   ),
              //   // );
              //   // if (list != null) {
              //   //   stockController.updateFavoriteList(list);
              //   // }
              // },
              child: const Icon(Icons.settings),
            ),
          ],
        ),
        child: Builder(builder: (context) {
          final list = favoriteList;
          if (list == null) {
            return loadingWidget();
          }
          if (list.isEmpty) {
            return emptyWidget();
          }
          return ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return const SizedBox(height: 8.0);
            },
            itemCount: list.length,
            itemBuilder: (context, index) {
              final stock = list[index];
              return Card(
                clipBehavior: Clip.hardEdge,
                child: Slidable(
                  endActionPane: ActionPane(
                    motion: const BehindMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {},
                        backgroundColor: const Color(0xFF21B7CA),
                        foregroundColor: Colors.white,
                        icon: Icons.share,
                        label: 'Share',
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          onTapRemove(stock);
                        },
                        backgroundColor: const Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: StockCard(
                    stock: stock,
                    onTap: () {
                      onTapStock(stock);
                    },
                    trailing: IVStockPriceBuilder(
                      stock: stock,
                      builder:
                          (indicator, percentageChange, netChage, lastPrice) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IntrinsicWidth(
                              child: Row(
                                children: [
                                  Text(indicator),
                                  Text("$percentageChange%"),
                                ],
                              ),
                            ),
                            Text(
                              IVNumberFormat.priceFormat(lastPrice),
                              style: const TextStyle(color: IVColor.white),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
