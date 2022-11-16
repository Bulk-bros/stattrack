import 'package:flutter/material.dart';
import 'package:stattrack/styles/font_styles.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({Key? key, required this.callback, required this.child})
      : super(key: key);

  final VoidCallback? callback;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: callback,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.all(16.0),
      ),
      child: child,
    );
  }
}
