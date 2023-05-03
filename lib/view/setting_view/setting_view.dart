import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:investing/controller/setting_controller.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  final controller = SettingController.find();
  AppBar appBar() {
    return AppBar(
      title: const Text("Setting View"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SingleChildScrollView(
        child: Obx(() {
          return Column(
            children: [
              // TODO: (Future Work) Fix light theme mode
              SwitchListTile(
                title: const Text("Dark Mode"),
                onChanged: (bool value) {
                  controller.toggleThemeMode();
                },
                value: controller.isDarkMode,
              )
            ],
          );
        }),
      ),
    );
  }
}
