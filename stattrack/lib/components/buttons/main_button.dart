import 'package:flutter/material.dart';
import 'package:stattrack/styles/font_styles.dart';
import 'package:stattrack/styles/palette.dart';

/// Custom button to be displayed as the main focusing point of a page
/// [callback] Function to be called when button is pressed
/// [label] Text displayed by the main button
/// [padding] Padding around the button
/// [backgroundColor] The main color of the button
/// [color] Color of the label
/// [borderColor] Color of the border surrounding the backgroundColor
/// [fontWeight] Weight of the label text
class MainButton extends StatelessWidget {
  const MainButton({
    Key? key,
    required this.callback,
    required this.label,
    this.elevation,
    this.padding,
    this.backgroundColor,
    this.color,
    this.borderColor,
    this.fontWeight,
  }) : super(key: key);

  final VoidCallback? callback;
  final String label;
  final double? elevation;
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
        elevation: elevation ?? 2,
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
