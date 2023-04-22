import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investing/const/color.dart';
import 'package:investing/controller/stock_controller.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/model/stock/stock_chart.dart';
import 'package:investing/view/watch_list_view/detail_view/stock_detail_view.dart';
import 'package:investing/widget/chart_widget.dart';
import 'package:investing/widget/loading_widget.dart';
import 'package:investing/widget/stock_price_builder.dart';
import 'package:investing/widget/title_widget.dart';

class IndexView extends StatefulWidget {
  const IndexView({super.key});

  @override
  State<IndexView> createState() => _IndexViewState();
}

class _IndexViewState extends State<IndexView> {
  final controller = StockController.find();
  @override
  void initState() {
    super.initState();
  }

  Widget item({
    required Stock index,
    required StockChart chart,
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
                  final textTheme = Theme.of(context).textTheme;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IgnorePointer(
                        child: IVChartWidget(
                          chart: chart,
                          showBaseLine: false,
                        ),
                      ),
                      AutoSizeText(
                        index.name,
                        maxLines: 1,
                      ),
                      IVStockPriceBuilder(
                        stock: index,
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
  Widget build(BuildContext context) {
    return TitleWidget(
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: const [
            Expanded(child: Text("Index")),
            Icon(Icons.settings),
          ],
        ),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        scrollDirection: Axis.horizontal,
        child: Obx(() {
          final indexList = controller.indexList;
          final chartList = controller.indexChartList;
          if (indexList.isEmpty) {
            return const IVLoadingWidget();
          }
          return Row(
            children: [
              for (int index = 0; index < chartList.length; ++index)
                item(
                  index: indexList[index],
                  chart: chartList[index],
                ),
            ],
          );
        }),
      ),
    );
  }
}
