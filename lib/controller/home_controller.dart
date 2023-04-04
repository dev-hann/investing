import 'package:investing/controller/controller.dart';
import 'package:flutter/material.dart';

class HomeController extends Controller {
  final PageController pageController = PageController(initialPage: 3);
  int _currentPage = 0;
  int get currentPage => _currentPage;
  void _pageControllerListener() {
    final page = pageController.page;
    if (page != null) {
      _currentPage = page.round();
      update();
    }
  }

  @override
  void onReady() {
    pageController.addListener(_pageControllerListener);

    super.onReady();
  }
}
