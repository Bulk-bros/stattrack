import 'package:flutter/material.dart';

/// Custom clickable card that displays information
/// [child] Widget to be displayed within the card
/// [onPressed] logic that should happen when the card is pressed
/// [backgroundColor] color of the clickable card
class ClickableCard extends StatelessWidget {
  const ClickableCard(
      {Key? key,
      required this.child,
      required this.onPressed,
      this.backgroundColor})
      : super(key: key);

  final Widget child;
  final void Function() onPressed;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? Colors.white,
          elevation: 25,
          padding: const EdgeInsets.all(20),
          shadowColor: Colors.black.withOpacity(0.40)),
      onPressed: onPressed,
      child: child,
    );
  }
}
