import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    super.key,
    this.gap = 8.0,
    required this.title,
    required this.child,
  });
  final Widget title;
  final double gap;
  final Widget child;
  static Widget withButton({
    required Widget title,
    required Widget trailing,
    required Widget child,
  }) {
    return TitleWidget(
      title: Row(
        children: [
          Expanded(child: title),
          Builder(builder: (context) {
            return DefaultTextStyle(
              style: Theme.of(context).textTheme.labelLarge!,
              child: trailing,
            );
          }),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DefaultTextStyle(
          style: Theme.of(context).textTheme.titleLarge!,
          child: title,
        ),
        SizedBox(height: gap),
        child,
      ],
    );
  }
}
