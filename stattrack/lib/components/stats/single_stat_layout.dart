import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:stattrack/styles/font_styles.dart';

/// Widget creating the layout for displaying a stat category and its amount
/// [categoryText] the name of the stat category
/// [amountText] the amount of the given category
/// [categoryTextSize] the size of the categoryText, default set to fs300 (13.0)
/// [amountTextSize] the size of the amountText, default set to fs400 (16.0)
/// [icon] an icon to be displayed to the right of an amountText default set to null
/// [color] the color of both text strings in the layout, default set to black (Colors.black)
///
class SingleStatLayout extends StatelessWidget {
  SingleStatLayout(
      {Key? key,
      required this.categoryText,
      this.content,
      this.amountText,
      this.categoryTextSize = FontStyles.fsBodySmall,
      this.amountTextSize = FontStyles.fsBody,
      this.icon,
      this.color = Colors.black})
      : super(key: key);

  String categoryText;
  Widget? content;
  double categoryTextSize;
  double amountTextSize;
  Color color = Colors.black;
  Icon? icon;
  String? amountText;

  @override
  Widget build(BuildContext context) {
    Widget toDisplay = _buildAmountText("No body defined");
    if (content != null) {
      toDisplay = content!;
    }
    if (amountText != null) {
      toDisplay = _buildAmountText(amountText!);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(categoryText,
            style: TextStyle(fontSize: categoryTextSize, color: color)),
        Row(
          children: [
            toDisplay,
            Transform.rotate(
              angle: -90 * math.pi / 180,
              child: icon ?? const Text(""),
            )
          ],
        )
      ],
    );
  }

  Widget _buildAmountText(String amountText) {
    return Text(
      amountText,
      style: TextStyle(
          fontSize: amountTextSize, fontWeight: FontStyles.fw600, color: color),
    );
  }
}
