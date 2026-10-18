import 'package:flutter/material.dart';

/// Pushes a full-screen [MaterialPageRoute], replacing the previous
/// `Get.to<void>(...)` calls.
Future<void> pushView(BuildContext context, Widget view) {
  return Navigator.of(context)
      .push<void>(MaterialPageRoute<void>(builder: (_) => view));
}
