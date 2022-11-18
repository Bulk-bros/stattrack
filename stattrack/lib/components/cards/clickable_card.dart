import 'package:flutter/material.dart';

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
    return TextButton(
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(5.0),
          ),
          color: backgroundColor ?? Colors.white,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(
                0,
                8,
              ),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
