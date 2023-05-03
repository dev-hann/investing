import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:investing/const/color.dart';
import 'package:investing/controller/stock_controller.dart';
import 'package:investing/util/number_format.dart';
import 'package:investing/view/stock_view/detail_view/stock_detail_view.dart';
import 'package:investing/view/stock_view/edit_view/edit_view.dart';
import 'package:investing/widget/shimmer.dart';
import 'package:investing/widget/stock_card.dart';
import 'package:investing/widget/stock_price_builder.dart';
import 'package:investing/widget/title_widget.dart';

// TODO: (Future Work)  make Favorite Directory
class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  final controller = StockController.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TitleWidget(
        title: Row(
          children: [
            const Expanded(child: Text("Favorites")),
            GestureDetector(
              onTap: () async {
                final list = await Get.to(
                  EditView(
                    itemList: controller.favoriteList,
                  ),
                );
                if (list != null) {
                  controller.updateFavoriteList(list);
                }
              },
              child: const Icon(Icons.settings),
            ),
          ],
        ),
        child: Obx(() {
          final favoriteList = controller.favoriteList;
          if (controller.favoriteLoading.isTrue) {
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
          if (favoriteList.isEmpty) {
            return SizedBox(
              height: Get.height / 3,
              child: const Center(
                child: Text("Favorite List is Empty!"),
              ),
            );
          }
          return ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return const SizedBox(height: 8.0);
            },
            itemCount: favoriteList.length,
            itemBuilder: (context, index) {
              final stock = favoriteList[index];
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
                        onPressed: (context) async {
                          await Future.delayed(
                              const Duration(milliseconds: 300));
                          controller.removeFavoriteStock(stock);
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
                      Get.to(
                        StockDetailView(stock: stock),
                      );
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
