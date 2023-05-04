import 'package:investing/model/news.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class NewsCard extends StatefulWidget {
  const NewsCard({
    super.key,
    required this.news,
    this.onTap,
  });
  final News news;
  final VoidCallback? onTap;

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  Widget titleWidget() {
    return Text(
      widget.news.title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: Get.textTheme.titleMedium,
    );
  }

  Widget subtitleWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.news.publisher,
          style: Get.textTheme.bodySmall,
        ),
        Text(
          widget.news.created ?? "",
          style: Get.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget headPhotWidget() {
    final headPhoto = widget.news.headPhoto;
    if (headPhoto == null) {
      return const SizedBox();
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: Image.network(
              widget.news.headPhoto!,
              width: width,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleWidget(),
          const SizedBox(height: 8.0),
          subtitleWidget(),
          headPhotWidget(),
        ],
      ),
    );
  }
}
