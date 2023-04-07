import 'dart:async';

import 'package:get/get.dart';
import 'package:investing/repo/repo.dart';

abstract class Controller<T extends Repo> extends GetxController {
  Controller(this.repo);
  final T repo;

  final Completer _initComputer = Completer();

  Future get loading => _initComputer.future;

  @override
  void onInit() async {
    await repo.init();
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
