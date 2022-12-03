import 'package:flutter/material.dart';

/// A custom button to be displayed as less important but still very visible
/// Can be used where many buttons are to be presented
/// [callback] The function to be called when pressed
/// [child] the widget to be displayed within this button
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
        padding: const EdgeInsets.all(20.0),
      ),
      child: child,
    );
  }
}
