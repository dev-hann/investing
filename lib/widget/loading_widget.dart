import 'package:flutter/material.dart';

class IVLoadingWidget extends StatelessWidget {
  const IVLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black.withOpacity(0.4),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
