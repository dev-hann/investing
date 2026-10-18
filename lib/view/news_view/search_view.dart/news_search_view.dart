import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:investing/controller/news_controller.dart';
import 'package:investing/model/news.dart';
import 'package:investing/util/navigator.dart';
import 'package:investing/view/news_view/detail_view/news_detail_view.dart';
import 'package:investing/widget/news_card.dart';
import 'package:investing/widget/text_field.dart';

class NewsSearchView extends ConsumerStatefulWidget {
  const NewsSearchView({super.key});

  @override
  ConsumerState<NewsSearchView> createState() => _NewsSearchViewState();
}

class _NewsSearchViewState extends ConsumerState<NewsSearchView> {
  List<News> searchedList = [];

  AppBar appBar() {
    return AppBar(title: const Text('Search News'));
  }

  Widget queryTextField({required void Function(String query) onSubmitted}) {
    return Card(
      child: CustomTextfield(
        textInputAction: TextInputAction.search,
        onSubmitted: onSubmitted,
        autoFocus: true,
        hintText: 'Aa',
      ),
    );
  }

  Widget searchedListWidget({
    required BuildContext context,
    required List<News> searchedList,
  }) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: searchedList.length,
      itemBuilder: (context, index) {
        final news = searchedList[index];
        return NewsCard(
          news: news,
          onTap: () async {
            unawaited(pushView(context, NewsDetailView(news: news)));
          },
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 16.0);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        physics: const BouncingScrollPhysics(),
        children: [
          queryTextField(
            onSubmitted: (query) async {
              final list = await ref
                  .read(newsControllerProvider.notifier)
                  .searchNews(query);
              if (mounted) {
                setState(() {
                  searchedList = list;
                });
              }
            },
          ),
          const SizedBox(height: 16.0),
          searchedListWidget(context: context, searchedList: searchedList),
        ],
      ),
    );
  }
}
