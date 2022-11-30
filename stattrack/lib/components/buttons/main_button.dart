import 'package:flutter/material.dart';
import 'package:stattrack/styles/font_styles.dart';
import 'package:stattrack/styles/palette.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    Key? key,
    required this.callback,
    required this.label,
    this.padding,
    this.backgroundColor,
    this.color,
    this.borderColor,
    this.fontWeight,
  }) : super(key: key);

  final VoidCallback? callback;
  final String label;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final Color? color;
  final Color? borderColor;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: callback,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Palette.accent[400],
        padding: padding ?? const EdgeInsets.all(25.0),
        side: borderColor != null
            ? BorderSide(
                width: 1.0,
                color: borderColor!,
              )
            : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color ?? Colors.white,
          fontWeight: fontWeight ?? FontStyles.fw600,
          fontSize: FontStyles.fs400,
        ),
      ),
    );
  }
}
