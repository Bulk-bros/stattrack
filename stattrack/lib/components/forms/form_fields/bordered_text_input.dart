import 'package:flutter/material.dart';

class BorderedTextInput extends StatelessWidget {
  const BorderedTextInput({
    Key? key,
    this.controller,
    this.focusNode,
    required this.hintText,
    this.errorText,
    this.textInputAction,
    this.keyboardType,
    this.onEditingComplete,
    this.onChanged,
  }) : super(key: key);

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String hintText;
  final String? errorText;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final void Function()? onEditingComplete;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: hintText,
        errorText: errorText,
        fillColor: Colors.white12,
        filled: true,
        border: const OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.grey,
        )),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.grey,
        )),
      ),
      textInputAction: textInputAction,
      onEditingComplete: onEditingComplete,
      keyboardType: keyboardType,
      onChanged: onChanged,
    );
  }
}
