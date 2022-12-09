import 'package:flutter/material.dart';
import 'package:stattrack/components/buttons/main_button.dart';
import 'package:stattrack/styles/font_styles.dart';

class AccountSetupNoobVsPro extends StatelessWidget {
  const AccountSetupNoobVsPro({
    Key? key,
    required this.toPro,
    required this.toNoob,
  }) : super(key: key);

  final void Function() toPro;
  final void Function() toNoob;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Text(
          'Do you know your daily calorie consumption?',
          style: TextStyle(
            fontWeight: FontStyles.fwTitle,
          ),
        ),
        const SizedBox(
          height: 25.0,
        ),
        MainButton(
          callback: toPro,
          label: 'Yes, let me set it myself',
        ),
        const SizedBox(
          height: 16.0,
        ),
        MainButton(
          callback: toNoob,
          label: 'No, take me through the setup',
        ),
      ],
    );
  }
}
