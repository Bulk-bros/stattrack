import 'package:flutter/material.dart';

class BorderedTextInput extends StatelessWidget {
  const BorderedTextInput(
      {Key? key,
      this.controller,
      required this.hintText,
      this.textInputAction,
      this.keyboardType,
      this.onEditingComplete,
      this.onChanged})
      : super(key: key);

  final TextEditingController? controller;
  final String hintText;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final void Function()? onEditingComplete;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
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
