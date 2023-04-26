import 'package:get/get.dart';
import 'package:investing/controller/stock_controller.dart';
import 'package:investing/model/date_time_range.dart';
import 'package:investing/model/stock/stock.dart';
import 'package:investing/model/stock/stock_chart.dart';
import 'package:investing/model/stock/stock_detail.dart';
import 'package:investing/model/stock/stock_dividend.dart';
import 'package:investing/model/stock/stock_financial.dart';
import 'package:investing/util/number_format.dart';
import 'package:investing/view/stock_view/detail_view/dividend_view/dividend_view.dart';
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
  final StockController controller = StockController.find();
  late final stock = widget.stock;
  late final Rx<StockDetail> stockDetail = Rx<StockDetail>(
    StockDetail(dateTimeRange: stock.dateTimeList.first),
  );

  StockDetail get detailValue => stockDetail.value;

  @override
  void initState() {
    super.initState();
    requestStockChart(stock.dateTimeList.first);
    requestStockFinacial();
    requestStockDividned();
  }

  Future requestStockChart(IVDateTimeRange dateTimeRange) async {
    if (!detailValue.containsChart(dateTimeRange)) {
      final data = await controller.requestStockChart(
        stock: stock,
        dateTimeRange: dateTimeRange,
      );
      stockDetail(
        detailValue.copyWith(
          dateTimeRange: dateTimeRange,
          chartMap: {
            dateTimeRange: data,
          }..addAll(detailValue.chartMap),
        ),
      );
    }
  }

  Future requestStockFinacial() async {
    final financial = await controller.requestStockFinancial(
      stock: stock,
      type: FinancialType.annual,
    );
    stockDetail(
      detailValue.copyWith(
        financial: financial,
      ),
    );
  }

  Future requestStockDividned() async {
    final dividend = await controller.requestStockDividend(stock);

    stockDetail(
      detailValue.copyWith(
        dividend: dividend,
      ),
    );
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
              builder: (indicator, percentageChange, netChage, lastPrice) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      IVNumberFormat.priceFormat(lastPrice),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Row(
                      children: [
                        Text(indicator),
                        Text("$percentageChange%"),
                        Text("($netChage)"),
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

  Widget chartButtonListView({
    required IVDateTimeRange selected,
    required List<IVDateTimeRange> dateTimeList,
  }) {
    final selectedIndex = dateTimeList.indexWhere(
      (element) {
        return element.isEqual(selected);
      },
    );
    return IVChartButton(
      selectedIndex: selectedIndex,
      onTap: (index) {
        final item = dateTimeList[index];
        requestStockChart(item);
      },
      dateTimeList: dateTimeList,
    );
  }

  Widget chartWidget(StockChart? chart) {
    return IVChartWidget(
      stockChart: chart,
      enableGesture: true,
      showBaseLine: true,
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

  Widget financialWidget(StockFinancial? financial) {
    if (financial == null) {
      return const SizedBox();
    }
    return TitleWidget(
      title: const Text("Financial"),
      child: Text(
        financial.balanceTable.toString(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Obx(() {
        final dividendValue = detailValue.dividend;
        final financialValue = detailValue.financial;
        final chartValue = detailValue.chart;
        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            titleText(),
            Padding(
              padding: const EdgeInsets.only(
                top: 56.0,
                bottom: 16.0,
              ),
              child: chartWidget(chartValue),
            ),
            chartButtonListView(
              selected: detailValue.dateTimeRange,
              dateTimeList: stock.dateTimeList,
            ),
            const SizedBox(height: 16.0),
            dividendWidget(dividendValue),
            const SizedBox(height: 16.0),
            financialWidget(financialValue),
          ],
        );
      }),
    );
  }
}
