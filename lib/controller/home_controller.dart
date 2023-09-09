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

  int currentIndex = 0;

  void moveToPage(PageType pageType) {
    currentIndex = pageType.index;
    update();
  }
}
