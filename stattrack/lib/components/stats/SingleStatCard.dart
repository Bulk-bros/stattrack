import 'package:flutter/material.dart';

class SingleStatCard extends StatelessWidget {
  SingleStatCard({Key? key, required this.content, [this.size = 100]}) : super(key: key);

Widget content;
double size;

// move this to component folder
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