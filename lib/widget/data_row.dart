import 'package:flutter/widgets.dart';

class IVDateRow extends StatelessWidget {
  const IVDateRow({
    super.key,
    required this.title,
    required this.data,
  });
  final Widget title;
  final Widget data;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DefaultTextStyle(
            maxLines: 1,
            style: const TextStyle(
              overflow: TextOverflow.ellipsis,
            ),
            child: title,
          ),
        ),
        data,
      ],
    );
  }
}
