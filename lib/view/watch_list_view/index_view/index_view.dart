import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investing/const/color.dart';
import 'package:investing/model/index.dart';
import 'package:investing/widget/title_widget.dart';

class IndexView extends StatelessWidget {
  const IndexView({
    super.key,
    required this.indexList,
  });
  final List<Index> indexList;

  double get size => Get.width / 2.5;

  Widget item(Index index) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: IVColor.blueGrey,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: SizedBox(
        width: size,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Builder(builder: (context) {
            final textTheme = Theme.of(context).textTheme;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "15분 지연",
                  style: textTheme.labelMedium,
                ),
                const Expanded(
                  child: ColoredBox(
                    color: Colors.white,
                    // child: Center(),
                  ),
                ),
                AutoSizeText(
                  index.name,
                  maxLines: 1,
                  // style: textTheme.bodySmall,
                ),
                Text(
                  index.lastSalePrice,
                  style: textTheme.titleMedium,
                ),
                // StockPriceText(
                //   closedPrice: ,
                //   currentPrice: ,
                // ),
              ],
            );
          }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final itemList = indexList;
    return TitleWidget(
      title: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text("Index"),
      ),
      child: SizedBox(
        height: size * 1.1,
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          itemCount: itemList.length,
          scrollDirection: Axis.horizontal,
          separatorBuilder: (context, index) {
            return const SizedBox(width: 8.0);
          },
          itemBuilder: (context, index) {
            return item(itemList[index]);
          },
        ),
      ),
    );
  }
}
