import 'package:flutter/material.dart';
import 'package:stattrack/components/stats/SingleStatLayout.dart';

import '../../styles/font_styles.dart';

/// A card that should display a single stat, placing it in the center of the main axis
/// [content] A widget that is to be displayed in the single stat card
/// [size] Size of the card, default is set to 100px
///
class SingleStatCard extends StatelessWidget {
  SingleStatCard({Key? key, required this.content, this.size = 100})
      : super(key: key);

  Widget content;
  double? size;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            padding: const EdgeInsets.all(20),
            height: size,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(0, 5))
              ],
            ),
            child: content)
      ],
    );
  }
}
