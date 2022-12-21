import 'package:flutter/material.dart';
import 'package:stattrack/components/buttons/main_button.dart';
import 'package:stattrack/components/layout/stattrack_column.dart';
import 'package:stattrack/styles/font_styles.dart';
import 'package:stattrack/styles/palette.dart';

class AccountSetupNoobActivity extends StatefulWidget {
  const AccountSetupNoobActivity({Key? key, required this.onComplete})
      : super(key: key);

  final void Function(int) onComplete;

  @override
  State<AccountSetupNoobActivity> createState() =>
      _AccountSetupNoobActivityState();
}

class _AccountSetupNoobActivityState extends State<AccountSetupNoobActivity> {
  int? _activityLevel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        StattrackColumn(
          gap: 'xl',
          children: [
            const Text(
              'How active are you on a regular basis? Select one of the options belove.',
              style: TextStyle(
                fontWeight: FontStyles.fwTitle,
              ),
            ),
            StattrackColumn(
              gap: 's',
              children: <Widget>[
                _buildButton(
                  id: 1,
                  title: 'Inactive',
                  text:
                      'If you have an office job, or another job where you sit still for most of the day.',
                ),
                _buildButton(
                  id: 2,
                  title: 'Moderate',
                  text:
                      'You have a job where you stand still for most of the day. E.g. teacher, receptionist, etc...',
                ),
                _buildButton(
                  id: 3,
                  title: 'Active',
                  text:
                      'You have a job where you are activly using your body. E.g. carpenter, warehouseworker, etc...',
                ),
              ],
            ),
          ],
        ),
        MainButton(
          onPressed: _activityLevel != null
              ? () => widget.onComplete(_activityLevel!)
              : null,
          label: 'Next',
        ),
      ],
    );
  }

  // TODO: Refactor into component, or use clickable component
  Widget _buildButton({
    required int id,
    required String title,
    required String text,
  }) {
    return ElevatedButton(
      onPressed: () => setState(() {
        _activityLevel = id;
      }),
      style: ElevatedButton.styleFrom(
        backgroundColor:
            _activityLevel == id ? Palette.accent[400] : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 31.0, horizontal: 16.0),
        foregroundColor: _activityLevel == id ? Colors.white : Colors.black87,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontStyles.fwTitle,
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontStyles.fwBody,
            ),
          ),
        ],
      ),
    );
  }
}
