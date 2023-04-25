import 'package:flutter/material.dart';

class IVAlert extends StatelessWidget {
  const IVAlert({
    super.key,
    this.title,
    this.content,
    this.actions,
  });
  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      actions: actions,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(16.0),
      // ),
    );
  }
}
