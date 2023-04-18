import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investing/const/color.dart';
import 'package:investing/controller/stock_controller.dart';
import 'package:investing/model/stock_detail.dart';
import 'package:investing/view/view.dart';
import 'package:investing/view/watch_list_view/detail_view/stock_detail_view.dart';
import 'package:investing/view/watch_list_view/index_view/index_view_model.dart';
import 'package:investing/widget/chart_widget.dart';
import 'package:investing/widget/stock_price_builder.dart';
import 'package:investing/widget/title_widget.dart';

class IndexView extends View<IndexViewModel, StockController> {
  IndexView({super.key}) : super(viewModel: IndexViewModel());

  Widget item(StockDetail indexDetail) {
    return GestureDetector(
      onTap: () {
        Get.to(
          StockDetailView(stock: indexDetail),
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
                  final textTheme = Theme.of(context).textTheme;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IgnorePointer(
                        child: IVChartWidget(
                          stockDetail: indexDetail,
                        ),
                      ),
                      AutoSizeText(
                        indexDetail.name,
                        maxLines: 1,
                      ),
                      IVStockPriceBuilder(
                        stock: indexDetail,
                        lastPriceStyle: textTheme.titleMedium,
                        netChangeBracket: true,
                        builder:
                            (indicator, percentageChange, netChage, lastPrice) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              lastPrice,
                              Row(
                                children: [
                                  indicator,
                                  percentageChange,
                                  netChage,
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
  Widget body() {
    final itemList = viewModel.indexDetailList;
    return TitleWidget(
      title: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text("Index"),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: itemList.map(item).toList(),
        ),
      ),
    );
  }
}
