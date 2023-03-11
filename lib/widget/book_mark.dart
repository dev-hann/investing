import 'package:flutter/material.dart';

class BookMarkWidget extends StatelessWidget {
  const BookMarkWidget({
    super.key,
    required this.isBookmark,
    required this.onTap,
    this.activeColor = Colors.orangeAccent,
    this.color = Colors.white,
  });
  final bool isBookmark;
  final VoidCallback onTap;
  final Color activeColor;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        isBookmark ? Icons.bookmark : Icons.bookmark_border,
        color: isBookmark ? activeColor : color,
      ),
    );
  }
}
