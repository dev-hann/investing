import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// Confirmation dialog built on Forui's [FDialog] (shadcn style).
///
/// Keeps the legacy `title`/`content`/`actions` parameter surface so existing
/// `showDialog` call sites work unchanged.
class IVAlert extends StatelessWidget {
  const IVAlert({super.key, this.title, this.content, this.actions});
  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return FDialog(
      builder: (context, style) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null)
              DefaultTextStyle(style: style.titleTextStyle, child: title!),
            if (title != null && content != null) const SizedBox(height: 8.0),
            if (content != null)
              DefaultTextStyle(style: style.bodyTextStyle, child: content!),
            if (actions?.isNotEmpty ?? false) ...[
              const SizedBox(height: 16.0),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: actions!),
            ],
          ],
        ),
      ),
    );
  }
}
