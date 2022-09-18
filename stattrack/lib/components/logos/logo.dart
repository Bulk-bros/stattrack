import 'package:flutter/cupertino.dart';

/// A widget display the logo
class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Stattrack',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 31.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
