import 'package:investing/model/stock/stock.dart';
import 'package:investing/util/number_format.dart';
import 'package:investing/view/stock_view/detail_view/chart_view/chart_view.dart';
import 'package:investing/view/stock_view/detail_view/company_view/company_view.dart';
import 'package:investing/view/stock_view/detail_view/dividend_view/dividend_view.dart';
import 'package:investing/view/stock_view/detail_view/financial_view/financial_view.dart';
import 'package:investing/view/stock_view/detail_view/stock_news_view/stock_news_view.dart';
import 'package:investing/widget/book_mark.dart';
import 'package:flutter/material.dart';
import 'package:investing/widget/stock_price_builder.dart';

class StockDetailView extends StatelessWidget {
  const StockDetailView({
    super.key,
    required this.stock,
  });
  final Stock stock;

  AppBar appBar() {
    Widget bookmarkWidget() {
      final type = stock.type;
      if (type == StockType.majorIndex ||
          type == StockType.commodity ||
          type == StockType.fixedIncome) {
        return const SizedBox();
      }
      return IconButton(
        onPressed: () {},
        icon: BookMarkWidget(
          stock: stock,
        ),
      );
    }

    return AppBar(
      title: const Text("Stock Detail"),
      actions: [
        bookmarkWidget(),
      ],
    );
  }

  Widget titleText() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          titleText(),
          ChartView(stock: stock),
          DividendView(stock: stock),
          StockNewsView(stock: stock),
          // FinancialView(stock: stock),
          CompanyView(stock: stock)
        ],
      ),
    );
  }
}
