import 'package:flutter/material.dart';
import 'package:investing/model/news.dart';

class NewsCard extends StatefulWidget {
  const NewsCard({super.key, required this.news, this.onTap});
  final News news;
  final VoidCallback? onTap;

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  Widget titleWidget(BuildContext context) {
    return Text(
      widget.news.title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  Widget subtitleWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.news.publisher,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          widget.news.created ?? '',
          style: Theme.of(context).textTheme.bodySmall,
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
            child: Image.network(widget.news.headPhoto!, width: width),
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
          titleWidget(context),
          const SizedBox(height: 8.0),
          subtitleWidget(context),
          headPhotWidget(),
        ],
      ),
    );
  }
}
