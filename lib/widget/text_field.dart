import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

/// Search-style text field built on Forui's [FTextField].
///
/// Keeps the legacy parameter surface (`onSubmitted`, `onChanged`,
/// `hintText`, `autoFocus`) so existing call sites work unchanged.
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
  final void Function(String text)? onSubmitted;
  final void Function(String text)? onChanged;
  final TextInputAction? textInputAction;
  final String? hintText;
  final bool autoFocus;

  @override
  Widget build(BuildContext context) {
    return FTextField(
      control: FTextFieldControl.managed(
        controller: controller,
        onChange: onChanged == null ? null : (value) => onChanged!(value.text),
      ),
      autofocus: autoFocus,
      hint: hintText,
      textInputAction: textInputAction,
      onSubmit: onSubmitted,
    );
  }
}
