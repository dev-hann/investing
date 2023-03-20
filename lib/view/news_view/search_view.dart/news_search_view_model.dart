import 'package:dividends_manager/controller/news_controller.dart';
import 'package:dividends_manager/model/news.dart';
import 'package:dividends_manager/view/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewsSearchViewModel extends ViewModel<NewsController> {
  final List<News> searchedList = [];
  final TextEditingController queryCntroller = TextEditingController();
  final RxString queryValue = RxString("");
  late final Worker _queryWoker;

  @override
  Future init() {
    _queryWoker = debounce(queryValue, (query) {
      searchNews(query);
    }, time: const Duration(milliseconds: 500));
    return super.init();
  }

  @override
  Future dispose() {
    _queryWoker.dispose();
    return super.dispose();
  }

  void searchNews(String query) async {
    if (query.isEmpty) {
      return;
    }
    final list = await controller.searchNews(query);
    searchedList.clear();
    searchedList.addAll(list);
    controller.update();
  }
}
