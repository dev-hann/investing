import 'package:flutter/material.dart';
import 'package:investing/const/color.dart';

class IVTextButton extends StatelessWidget {
  const IVTextButton({
    super.key,
    this.style,
    required this.onTap,
    required this.child,
  });
  final VoidCallback onTap;
  final TextStyle? style;
  final Widget child;

  factory IVTextButton.more({
    required VoidCallback onTap,
  }) {
    return IVTextButton(
      onTap: onTap,
      child: Row(
        children: const [
          Text("More"),
          Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: IconTheme(
        data: const IconThemeData(
          color: IVColor.orange,
          size: 12.0,
        ),
        child: DefaultTextStyle(
          style: style ??
              const TextStyle(
                color: IVColor.orange,
              ),
          child: child,
        ),
      ),
    );
  }
}
