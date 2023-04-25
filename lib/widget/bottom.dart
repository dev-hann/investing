import 'package:flutter/cupertino.dart';

class IVBottom extends StatelessWidget {
  const IVBottom({
    super.key,
    this.title,
    this.message,
    this.actions,
  });
  final Widget? title;
  final Widget? message;
  final List<IVBottomButton>? actions;

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheet(
      title: title,
      message: message,
      actions: actions,
    );
  }
}

class IVBottomButton extends StatelessWidget {
  const IVBottomButton({
    super.key,
    required this.onTap,
    required this.child,
    this.isBold = false,
    this.isRed = false,
  });
  final VoidCallback onTap;
  final Widget child;
  final bool isRed;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return CupertinoActionSheetAction(
      isDefaultAction: isBold,
      isDestructiveAction: isRed,
      onPressed: onTap,
      child: child,
    );
  }
}
