import 'package:flutter/material.dart';

/// A layout component for spacing
///
/// [direction] the direction the spacing should occupy. Either `x` for
/// horizontal, `y` for vertical or `xy` for both directions.
/// [amount] a keyword describing the amount to add to the
/// spacing:
///   `xt = 2.0`
///   `t = 4.0`
///   `xxs = 8.0`
///   `xs = 10.0`
///   `s = 13.0`
///   `m = 16.0`
///   `l = 20.0`
///   `xl = 25.0`
///   `xxl = 31.0`
///   `h = 39.0`
///   `xh = 48.0`
class Spacing extends StatelessWidget {
  const Spacing({
    Key? key,
    required this.direction,
    required this.amount,
  }) : super(key: key);

  final String direction;
  final String amount;

  @override
  Widget build(BuildContext context) {
    // Deside spacing value
    double spacing;
    switch (amount) {
      case 'xt':
        spacing = 2.0;
        break;
      case 't':
        spacing = 4.0;
        break;
      case 'xxs':
        spacing = 8.0;
        break;
      case 'xs':
        spacing = 10.0;
        break;
      case 's':
        spacing = 13.0;
        break;
      case 'm':
        spacing = 16.0;
        break;
      case 'l':
        spacing = 20.0;
        break;
      case 'xl':
        spacing = 25.0;
        break;
      case 'xxl':
        spacing = 31.0;
        break;
      case 'h':
        spacing = 39.0;
        break;
      case 'xh':
        spacing = 48.0;
        break;
      default:
        spacing = 16.0;
        break;
    }

    // Return correct direction
    switch (direction) {
      case 'x':
        return SizedBox(
          width: spacing,
        );
      case 'y':
        return SizedBox(
          height: spacing,
        );
      default:
        return SizedBox(
          width: spacing,
          height: spacing,
        );
    }
  }
}
