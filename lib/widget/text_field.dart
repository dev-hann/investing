import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield({
    super.key,
    this.controller,
    this.onSubmitted,
    this.onChanged,
    this.hintText,
    this.textInputAction,
    this.autoFocus = false,
  });
  final TextEditingController? controller;
  final Function(String text)? onSubmitted;
  final Function(String text)? onChanged;
  final TextInputAction? textInputAction;
  final String? hintText;
  final bool autoFocus;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: autoFocus,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        hintText: hintText,
      ),
    );
  }
}
