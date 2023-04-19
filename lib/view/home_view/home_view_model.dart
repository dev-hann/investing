import 'package:investing/controller/home_controller.dart';
import 'package:investing/view/view.dart';
import 'package:flutter/material.dart';

class HomeViewModel extends ViewModel<HomeController> {
  PageController get pageController => controller.pageController;

  int get currentPage => controller.currentPage;
  void onChangedPage(int index) {
    pageController.jumpToPage(index);
    updateView();
  }
}
