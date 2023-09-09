import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investing/const/color.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/util/number_format.dart';
import 'package:investing/view/stock_view/detail_view/stock_detail_view.dart';
import 'package:investing/widget/shimmer.dart';
import 'package:investing/widget/stock_price_builder.dart';
import 'package:investing/widget/title_widget.dart';

class IndexView extends StatelessWidget {
  const IndexView({
    super.key,
    required this.indexList,
  });
  final List<Stock>? indexList;

  Widget loadingItem() {
    final width = Get.width / 2.5;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: IVShimmer(
        width: width,
        height: width,
      ),
    );
  }

  Widget item({
    required Stock index,
  }) {
    return GestureDetector(
      onTap: () {
        Get.to(
          StockDetailView(stock: index),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: IVColor.blueGrey,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: SizedBox(
            width: Get.width / 2.5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Builder(
                builder: (context) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AutoSizeText(
                            index.name,
                            maxLines: 1,
                          ),
                          const Icon(Icons.arrow_forward_ios)
                        ],
                      ),
                      IVStockPriceBuilder(
                        stock: index,
                        builder:
                            (indicator, percentageChange, netChage, lastPrice) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                IVNumberFormat.indexFormat(lastPrice),
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Row(
                                children: [
                                  Text(indicator),
                                  Text("$percentageChange%"),
                                  Text("($netChage)"),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TitleWidget(
      title: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text("Index"),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        scrollDirection: Axis.horizontal,
        child: Builder(
          builder: (context) {
            final list = indexList;
            if (list == null) {
              return Row(
                children: [
                  for (int index = 0; index < 10; ++index) loadingItem(),
                ],
              );
            }
            return Row(
              children: list.map((e) => item(index: e)).toList(),
            );
          },
        ),
      ),
    );
  }
}
