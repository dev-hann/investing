import 'dart:async';

import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

abstract class Controller<T> extends GetxController {
  final Completer _initComputer = Completer();
  Future get loading => _initComputer.future;
  @override
  void onReady() {
    super.onReady();
    _initComputer.complete();
  }
}
