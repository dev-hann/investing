import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// Compact inline action button (used in app bar trailing slots) built on
/// Forui's [FButton] ghost variant so it inherits the app theme.
class IVTextButton extends StatelessWidget {
  const IVTextButton({super.key, required this.onTap, required this.child});
  final VoidCallback onTap;
  final Widget child;

  factory IVTextButton.more({required VoidCallback onTap}) {
    return IVTextButton(
      onTap: onTap,
      child: const Row(children: [Text('More'), Icon(Icons.arrow_forward_ios)]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FButton(
      variant: FButtonVariant.ghost,
      onPress: onTap,
      mainAxisSize: MainAxisSize.min,
      child: child,
    );
  }
}
