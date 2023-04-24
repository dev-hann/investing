import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investing/use_case/use_case.dart';
import 'package:investing/widget/loading_widget.dart';

abstract class Controller<T extends UseCase> extends GetxController {
  Controller(this.useCase);
  final T useCase;

  final Completer _initComputer = Completer();

  Future get loading => _initComputer.future;

  Future<O?> bottomSheet<O>(
    Widget widget, {
    bool isScrollControlled = true,
    bool ignoreSafeArea = false,
  }) {
    return Get.bottomSheet<O>(
      widget,
      isScrollControlled: isScrollControlled,
      ignoreSafeArea: ignoreSafeArea,
    );
  }

  Future<O> showOverlay<O>(
    Future<O> Function() asyncFunction,
  ) {
    return Get.showOverlay<O>(
      asyncFunction: asyncFunction,
      loadingWidget: const IVLoadingWidget(),
    );
  }

  @override
  void onReady() async {
    await useCase.init();
    super.onReady();
    _initComputer.complete();
  }

  static T put<T extends Controller>(T controller) {
    return Get.put<T>(controller);
  }

  final List _idList = [];
  void addViewID(dynamic viewID) {
    if (!_idList.contains(viewID)) {
      _idList.add(viewID);
    }
  }

  void removeViewID(dynamic viewID) {
    _idList.remove(viewID);
  }

  void updateView() {
    update([..._idList]);
  }

  void updateViewByID(dynamic viewID) {
    update([viewID]);
  }
}
