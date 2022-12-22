import 'package:flutter/material.dart';

/// A layout component for columns
///
/// Exposes a gap property that is applied as spacing in between each
/// item in the children list
///
/// [children] a list of widget to render in the column
/// [gap] the gap to set in between each child
/// Gap can be set to the following:
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
class StattrackColumn extends StatelessWidget {
  const StattrackColumn({
    Key? key,
    required this.gap,
    required this.children,
  }) : super(key: key);

  final String gap;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    double spacing;
    switch (gap) {
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

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: spacing,
        );
      },
      itemCount: children.length,
      itemBuilder: (context, index) {
        return children[index];
      },
    );
  }
}
