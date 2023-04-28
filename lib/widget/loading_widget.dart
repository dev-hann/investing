import 'package:flutter/material.dart';

class IVLoadingWidget extends StatelessWidget {
  const IVLoadingWidget({
    super.key,
    this.background,
  });
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Colors.transparent,
      // color: background ?? Colors.black.withOpacity(0.4),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
