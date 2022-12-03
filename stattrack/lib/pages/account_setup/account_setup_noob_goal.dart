import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';
import 'package:stattrack/components/buttons/main_button.dart';
import 'package:stattrack/styles/font_styles.dart';
import 'package:stattrack/styles/palette.dart';

class AccountSetupNoobGoal extends StatefulWidget {
  const AccountSetupNoobGoal({Key? key, required this.onComplete})
      : super(key: key);

  final void Function(String) onComplete;

  @override
  _AccountSetupNoobGoalState createState() => _AccountSetupNoobGoalState();
}

class _AccountSetupNoobGoalState extends State<AccountSetupNoobGoal> {
  String? _goal;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Do you want to gain, lose or stay at your bodyweight?',
              style: TextStyle(
                fontWeight: FontStyles.fwTitle,
              ),
            ),
            const SizedBox(
              height: 25.0,
            ),
            RowSuper(
              fitHorizontally: true,
              mainAxisSize: MainAxisSize.max,
              fill: true,
              children: <Widget>[
                _buildButton(
                  id: 'gain',
                  label: 'Gain weight',
                ),
                _buildButton(
                  id: 'lose',
                  label: 'Lose weight',
                ),
                _buildButton(
                  id: 'stay',
                  label: 'Stay at weight',
                ),
              ],
            ),
          ],
        ),
        MainButton(
          callback: _goal != null ? () => widget.onComplete(_goal!) : null,
          label: 'Next',
        ),
      ],
    );
  }

  Widget _buildButton({required String id, required String label}) {
    return ElevatedButton(
      onPressed: () => setState(() {
        _goal = id;
      }),
      style: ElevatedButton.styleFrom(
        backgroundColor: _goal == id ? Palette.accent[400] : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 31.0, horizontal: 16.0),
        foregroundColor: _goal == id ? Colors.white : Colors.black87,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontStyles.fwTitle,
            ),
          ),
        ],
      ),
    );
  }
}
