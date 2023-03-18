import 'dart:async';

import 'package:get/get.dart';

abstract class Controller extends GetxController {
  final Completer _initComputer = Completer();
  Future get loading => _initComputer.future;
  @override
  void onReady() {
    super.onReady();
    _initComputer.complete();
  }

  static T put<T extends Controller>(T controller) {
    return Get.put<T>(controller);
  }
}
