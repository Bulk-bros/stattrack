import 'package:flutter/material.dart';

class BorderedTextInput extends StatelessWidget {
  const BorderedTextInput(
      {Key? key,
      required this.controller,
      required this.hintText,
      required this.textInputAction,
      required this.onEditingComplete,
      required this.onChanged})
      : super(key: key);

  final TextEditingController controller;
  final String hintText;
  final TextInputAction textInputAction;
  final void Function() onEditingComplete;
  final void Function(String) onChanged;

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
      onChanged: onChanged,
    );
  }
}
