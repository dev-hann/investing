import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  set themeMode(ThemeMode mode) => state = mode;
}

final settingControllerProvider =
    NotifierProvider<SettingController, ThemeMode>(SettingController.new);
