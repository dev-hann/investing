import 'package:highlight_text/highlight_text.dart';
import 'package:investing/const/color.dart';
import 'package:investing/widget/stock_card.dart';
import 'package:investing/widget/book_mark.dart';
import 'package:flutter/material.dart';

class StockSearchCard extends StockCard {
  const StockSearchCard({
    super.key,
    required super.stock,
    required super.onTap,
    required this.query,
  });
  final String query;
  Map<String, HighlightedWord> get words => {
        query: HighlightedWord(
          textStyle: const TextStyle(
            color: IVColor.orange,
          ),
        ),
      };

  @override
  Widget titleText() {
    return TextHighlight(
      text: stock.name,
      words: words,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  Widget subtitleText() {
    return TextHighlight(
      text: stock.symbol,
      words: words,
    );
  }

  @override
  Widget trailingWidget() {
    return BookMarkWidget(
      stock: stock,
    );
  }
}
