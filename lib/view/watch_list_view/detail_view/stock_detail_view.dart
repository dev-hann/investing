import 'package:get/get.dart';
import 'package:investing/controller/stock_controller.dart';
import 'package:investing/model/stock.dart';
import 'package:investing/model/stock_detail.dart';
import 'package:investing/model/stock_dividend.dart';
import 'package:investing/view/watch_list_view/detail_view/dividend_view/dividend_view.dart';
import 'package:investing/widget/book_mark.dart';
import 'package:flutter/material.dart';
import 'package:investing/widget/chart_button.dart';
import 'package:investing/widget/chart_widget.dart';
import 'package:investing/widget/stock_price_builder.dart';
import 'package:investing/widget/title_widget.dart';

class StockDetailView extends StatefulWidget {
  const StockDetailView({
    super.key,
    required this.stock,
  });
  final Stock stock;

  @override
  State<StockDetailView> createState() => _StockDetailViewState();
}

class _StockDetailViewState extends State<StockDetailView> {
  final controller = StockController.find();
  final Rxn<StockDetail> detail = Rxn();
  final Rxn<StockDividend> dividend = Rxn();
  @override
  void initState() {
    super.initState();
    final stock = widget.stock;
    detail(StockDetail.fromStock(stock));
    controller.requestStockDetail(detail.value!).then(detail);
    controller.requestStockDividend(stock).then(dividend);
  }

  AppBar appBar() {
    return AppBar(
      title: const Text("Stock Detail"),
      actions: [
        // TODO: hide when stock is IndexType
        IconButton(
          onPressed: () {},
          icon: BookMarkWidget(
            stock: widget.stock,
          ),
        ),
      ],
    );
  }

  Widget titleText() {
    final stock = widget.stock;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(stock.name),
        Text(stock.symbol),
        Builder(
          builder: (context) {
            return IVStockPriceBuilder(
              stock: stock,
              lastPriceStyle: Theme.of(context).textTheme.titleLarge,
              netChangeBracket: true,
              builder: (indicator, percentageChange, netChage, lastPrice) {
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
                    )
                  ],
                );
              },
            );
          },
        )
      ],
    );
  }

  Widget chartButtonListView() {
    return IVChartButton(
      onTap: (index) {},
      itemList: const [
        ChartButtonItem(text: "1일"),
        ChartButtonItem(text: "1주"),
        ChartButtonItem(text: "1달"),
        ChartButtonItem(text: "3달"),
        ChartButtonItem(text: "1년"),
        ChartButtonItem(text: "전체"),
      ],
    );
  }

  Widget chartWidget(StockDetail detail) {
    return IVChartWidget(
      stockDetail: detail,
      enableGesture: true,
    );
  }

  Widget dividendWidget(StockDividend? dividend) {
    if (dividend == null) {
      return const SizedBox();
    }
    return TitleWidget(
      title: const Text("Dividend"),
      child: Column(
        children: [
          Row(
            children: [
              const Text("Annual Dividend"),
              Text(dividend.annualizedDividend.toString()),
            ],
          ),
          Row(
            children: [
              const Text("Dividend Ratio"),
              Text(dividend.yield.toString()),
            ],
          ),
          Row(
            children: [
              const Text("Ex Dividend Date"),
              Text(dividend.exDividendDate.toString()),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              controller.bottomSheet(
                DividendView(dividend: dividend),
              );
            },
            child: const Text("More"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Obx(() {
        final detailValue = detail.value;
        final dividendValue = dividend.value;
        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            titleText(),
            Padding(
              padding: const EdgeInsets.only(
                top: 56.0,
                bottom: 16.0,
              ),
              child: chartWidget(detailValue!),
            ),
            chartButtonListView(),
            const SizedBox(height: 16.0),
            dividendWidget(dividendValue)
          ],
        );
      }),
    );
  }
}
