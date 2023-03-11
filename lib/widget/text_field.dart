import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield({
    super.key,
    this.controller,
    this.onSubmitted,
    this.onChanged,
    this.hintText,
  });
  final TextEditingController? controller;
  final Function(String text)? onSubmitted;
  final Function(String text)? onChanged;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        hintText: hintText,
      ),
    );
  }
}
