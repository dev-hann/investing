import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    super.key,
    this.trailing,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    required this.title,
    required this.child,
  });
  final EdgeInsets padding;
  final Widget title;
  final Widget? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: padding,
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.titleLarge!,
            child: Row(
              children: [
                Expanded(child: title),
                trailing ?? const SizedBox(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        child,
      ],
    );
  }
}
