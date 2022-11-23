import 'package:flutter/material.dart';
import 'package:stattrack/styles/font_styles.dart';
import 'package:stattrack/styles/palette.dart';

class MainButton extends StatelessWidget {
  const MainButton(
      {Key? key, required this.callback, required this.label, this.padding})
      : super(key: key);

  final VoidCallback? callback;
  final String label;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: callback,
      style: ElevatedButton.styleFrom(
        backgroundColor: Palette.accent[400],
        padding: padding ?? const EdgeInsets.all(25.0),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontStyles.fw600,
          fontSize: FontStyles.fs400,
        ),
      ),
    );
  }
}
