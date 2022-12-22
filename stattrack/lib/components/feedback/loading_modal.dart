import 'package:flutter/material.dart';
import 'package:stattrack/styles/palette.dart';

class LoadingModal extends StatelessWidget {
  const LoadingModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            5.0,
          ),
        ),
      ),
      content: SizedBox(
        height: 100,
        child: Center(
          child: CircularProgressIndicator(
            color: Palette.accent[400],
          ),
        ),
      ),
    );
  }
}
