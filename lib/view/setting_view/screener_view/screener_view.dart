import 'package:flutter/material.dart';

class ScreenerView extends StatefulWidget {
  const ScreenerView({super.key});

  @override
  State<ScreenerView> createState() => _ScreenerViewState();
}

class _ScreenerViewState extends State<ScreenerView> {
  AppBar appBar() {
    return AppBar(
      title: const Text("Screener"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
    );
  }
}
