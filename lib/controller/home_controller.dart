import 'package:get/get.dart';
import 'package:investing/controller/controller.dart';
import 'package:investing/use_case/home_use_cas.dart';

enum PageType {
  watchList,
  news,
  event,
  map,
  setting,
}

class HomeController extends Controller<HomeUseCase> {
  HomeController(super.useCase);
  static HomeController find() => Get.find();

  int _currentIndex = 0;
  PageType get currentPage => PageType.values[_currentIndex];

  void moveToPage(PageType pageType) {
    _currentIndex = pageType.index;
    update();
  }
}
