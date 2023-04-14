import 'package:highlight_text/highlight_text.dart';
import 'package:investing/const/color.dart';
import 'package:investing/widget/stock_card.dart';
import 'package:investing/widget/book_mark.dart';
import 'package:flutter/material.dart';
import 'package:investing/widget/stock_listener_widget.dart';

class StockSearchCard extends StockCard {
  const StockSearchCard({
    super.key,
    required super.stock,
    required super.onTap,
    required this.isBookmakred,
    required this.onTapBookmark,
    required this.query,
  });
  final VoidCallback onTapBookmark;
  final bool isBookmakred;
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
      onTap: onTapBookmark,
      isBookmark: isBookmakred,
    );
  }
}
