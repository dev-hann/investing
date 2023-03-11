import 'package:dividends_manager/view/stock_view/widget/stock_card.dart';
import 'package:dividends_manager/widget/book_mark.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class StockSearchCard extends StockCard {
  StockSearchCard({
    super.key,
    required super.stock,
    required super.onTap,
    required this.isBookmark,
    required this.onTapBookmark,
  }) : super(
          enableSlide: false,
          onTapRemove: () {},
        );
  final VoidCallback onTapBookmark;
  final bool isBookmark;

  @override
  Widget trailingText() {
    return BookMarkWidget(
      onTap: onTapBookmark,
      isBookmark: isBookmark,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: Slidable(
          enabled: enableSlide,
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
                onPressed: (context) {
                  onTapRemove();
                },
                backgroundColor: const Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: ListTile(
            title: titleText(),
            subtitle: subtitleText(),
            trailing: trailingText(),
          ),
        ),
      ),
    );
  }
}
