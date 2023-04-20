import 'package:flutter/material.dart';

class IVLoadingWidget extends StatelessWidget {
  const IVLoadingWidget({
    super.key,
    this.background,
  });
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: background ?? Colors.black.withOpacity(0.4),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
