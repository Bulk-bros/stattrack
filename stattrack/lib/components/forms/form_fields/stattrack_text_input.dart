import 'package:flutter/material.dart';
import 'package:stattrack/styles/palette.dart';

class StattrackTextInput extends StatelessWidget {
  const StattrackTextInput({
    Key? key,
    required this.label,
    this.errorText,
    this.controller,
    this.focusNode,
    this.textInputAction,
    this.keyboardType,
    this.autocorrect = false,
    this.obscureText = false,
    this.onEditingComplete,
    this.onChanged,
  }) : super(key: key);

  final String label;
  final String? errorText;

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final bool autocorrect;
  final bool obscureText;

  final void Function()? onEditingComplete;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    var errorColor = Palette.error[900]!;

    return TextField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      autocorrect: autocorrect,
      obscureText: obscureText,
      onEditingComplete: onEditingComplete,
      onChanged: onChanged,
      decoration: InputDecoration(
        label: Text(
          label,
          style: TextStyle(
            color: errorText == null ? Palette.main[600] : errorColor,
          ),
        ),
        errorText: errorText,
        errorMaxLines: 3,
        filled: true,
        fillColor: Palette.main[100],
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Palette.main[400]!,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Palette.main[600]!,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: errorColor,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: errorColor,
          ),
        ),
      ),
    );
  }
}
