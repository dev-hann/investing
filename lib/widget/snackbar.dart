import 'package:flutter/material.dart';

/// Global key so layers without a [BuildContext] (e.g. controllers) can
/// show snackbars once wired into [MaterialApp.scaffoldMessengerKey].
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void showIVSnackbar(String title, String message) {
  scaffoldMessengerKey.currentState?.showSnackBar(
    SnackBar(content: Text('$title\n$message')),
  );
}
