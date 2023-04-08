import 'dart:async';

import 'package:get/get.dart';
import 'package:investing/use_case/use_case.dart';

abstract class Controller<T extends UseCase> extends GetxController {
  Controller(this.useCase);
  final T useCase;

  final Completer _initComputer = Completer();

  Future get loading => _initComputer.future;

  @override
  void onInit() async {
    await useCase.init();
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    _initComputer.complete();
  }

  static T put<T extends Controller>(T controller) {
    return Get.put<T>(controller);
  }
}
