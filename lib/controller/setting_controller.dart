import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investing/controller/controller.dart';
import 'package:investing/use_case/setting_use_case.dart';

class SettingController extends Controller<SettingUseCase> {
  SettingController(super.useCase);
  static SettingController find() => Get.find<SettingController>();

  final RxBool _themeMode = RxBool(false);
  bool get isDarkMode => _themeMode.value;
  @override
  void onReady() {
    super.onReady();
    _themeMode(Get.isDarkMode);
  }

  void toggleThemeMode() {
    Get.changeThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
    _themeMode.toggle();
  }
}
