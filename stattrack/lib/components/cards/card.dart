import 'package:flutter/material.dart';

/// A card that should display a single stat, placing it in the center of the main axis
/// [content] A widget that is to be displayed in the single stat card
/// [size] Size of the card, default is set to 100px
///
class SingleStatCard extends StatelessWidget {
  SingleStatCard(
      {Key? key,
      required this.content,
      this.size,
      this.padded = true,
      this.color = Colors.white})
      : super(key: key);

  Widget content;
  double? size;
  bool? padded;
  Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padded! ? const EdgeInsets.all(20) : const EdgeInsets.all(0),
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.10),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, 5))
        ],
      ),
      child: content,
    );
  }
}
