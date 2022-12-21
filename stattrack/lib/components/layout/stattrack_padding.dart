import 'package:flutter/material.dart';

/// A layout component for padding
///
/// [direction] the direction the padding should be applied. Either [x] for
/// horizontal, [y] for vertical or [xy] for both directions.
/// [amount] a keyword describing the amount to add to the
/// padding: [xtiny, tiny, xxs, xs, s, m, l, xl, xxl, huge, xhuge]
class StattrackPadding extends StatelessWidget {
  const StattrackPadding({
    Key? key,
    required this.direction,
    required this.amount,
    required this.child,
  }) : super(key: key);

  final String direction;
  final String amount;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Deside spacing value
    double spacing;
    switch (amount) {
      case 'xtiny':
        spacing = 2.0;
        break;
      case 'tiny':
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
      case 'huge':
        spacing = 39.0;
        break;
      case 'xhuge':
        spacing = 48.0;
        break;
      default:
        spacing = 16.0;
        break;
    }

    // Return correct direction
    switch (direction) {
      case 'x':
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing),
          child: child,
        );
      case 'y':
        return Padding(
          padding: EdgeInsets.symmetric(vertical: spacing),
          child: child,
        );
      default:
        return Padding(
          padding: EdgeInsets.all(spacing),
          child: child,
        );
    }
  }
}
