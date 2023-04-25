import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:investing/const/color.dart';
import 'package:investing/model/stock/stock.dart';

class StockCard extends StatelessWidget {
  const StockCard({
    super.key,
    required this.stock,
    this.onTap,
    this.highlight = "",
    this.leading,
    this.trailing,
  });
  final Stock stock;
  final VoidCallback? onTap;
  final String highlight;
  final Widget? trailing;
  final Widget? leading;

  Map<String, HighlightedWord> get words => {
        highlight: HighlightedWord(
          textStyle: const TextStyle(
            color: IVColor.orange,
          ),
        ),
      };
  Widget titleText() {
    return TextHighlight(
      text: stock.name,
      words: words,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget subtitleText() {
    return TextHighlight(
      text: stock.symbol,
      words: words,
    );
  }

  Widget? leadingWidget() {
    if (leading == null) {
      return null;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        leading!,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: leadingWidget(),
        title: titleText(),
        subtitle: subtitleText(),
        trailing: trailing,
        // trailingWidget(),
      ),
    );
  }
}
