import 'package:flutter/material.dart';
import 'package:stattrack/components/buttons/main_button.dart';
import 'package:stattrack/components/forms/form_fields/stattrack_text_input.dart';
import 'package:stattrack/components/layout/stattrack_column.dart';
import 'package:stattrack/styles/font_styles.dart';
import 'package:stattrack/utils/validator.dart';

class AccountSetupPro extends StatefulWidget {
  const AccountSetupPro({Key? key, required this.onComplete}) : super(key: key);

  final Future<void> Function(num, num, num, num) onComplete;

  @override
  State<AccountSetupPro> createState() => _AccountSetupProState();
}

class _AccountSetupProState extends State<AccountSetupPro> {
  final TextEditingController _calorieController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();

  final FocusNode _calorieFocusNode = FocusNode();
  final FocusNode _fatFocusNode = FocusNode();
  final FocusNode _carbsFocusNode = FocusNode();
  final FocusNode _proteinFocusNode = FocusNode();

  String get _calories => _calorieController.text;
  String get _fat => _fatController.text;
  String get _carbs => _carbsController.text;
  String get _proteins => _proteinController.text;

  bool get _isValidCalorie => Validator.isPositiveFloat(_calories);
  bool get _isValidFat => Validator.isPositiveFloat(_fat);
  bool get _isValidCarbs => Validator.isPositiveFloat(_carbs);
  bool get _isValidProtein => Validator.isPositiveFloat(_proteins);

  bool _showError = false;
  bool _isLoading = false;

  void _calorieEditingComplete() {
    final newFocus = _isValidCalorie ? _fatFocusNode : _calorieFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _fatEditingComplete() {
    final newFocus = _isValidCalorie ? _carbsFocusNode : _fatFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _carbsEditingComplete() {
    final newFocus = _isValidCarbs ? _proteinFocusNode : _carbsFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _submit() async {
    if (!_isValidCalorie ||
        !_isValidProtein ||
        !_isValidCarbs ||
        !_isValidFat) {
      setState(() {
        _showError = true;
      });
    } else {
      setState(() {
        _isLoading = true;
      });
      await widget.onComplete(num.parse(_calories), num.parse(_proteins),
          num.parse(_carbs), num.parse(_fat));
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StattrackColumn(
        gap: 'xxl',
        children: <Widget>[
          const Text(
            'Enter the values you need to reach your goal!',
            style: TextStyle(fontWeight: FontStyles.fwTitle),
          ),
          StattrackColumn(
            gap: 'm',
            children: <Widget>[
              StattrackTextInput(
                label: 'Calorie consumption',
                errorText: _showError && !_isValidCalorie
                    ? 'Only decimal numbers. Use "." instead of ","'
                    : null,
                controller: _calorieController,
                focusNode: _calorieFocusNode,
                textInputAction: TextInputAction.next,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                onEditingComplete: _calorieEditingComplete,
                onChanged: (calories) => _updateState(),
              ),
              StattrackTextInput(
                label: 'Fat consumption',
                errorText: _showError && !_isValidFat
                    ? 'Only decimal numbers. Use "." instead of ","'
                    : null,
                controller: _fatController,
                focusNode: _fatFocusNode,
                textInputAction: TextInputAction.next,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true, signed: true),
                onEditingComplete: _fatEditingComplete,
                onChanged: (fat) => _updateState(),
              ),
              StattrackTextInput(
                label: 'Carbs consumption',
                errorText: _showError && !_isValidCarbs
                    ? 'Only decimal numbers. Use "." instead of ","'
                    : null,
                controller: _carbsController,
                focusNode: _carbsFocusNode,
                textInputAction: TextInputAction.next,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true, signed: true),
                onEditingComplete: _carbsEditingComplete,
                onChanged: (carbs) => _updateState(),
              ),
              StattrackTextInput(
                label: 'Protein consumption',
                errorText: _showError && !_isValidProtein
                    ? 'Only decimal numbers. Use "." instead of ","'
                    : null,
                controller: _proteinController,
                focusNode: _proteinFocusNode,
                textInputAction: TextInputAction.done,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true, signed: true),
                onChanged: (protein) => _updateState(),
              ),
            ],
          ),
          MainButton(
            onPressed: _isLoading ? null : _submit,
            label: 'Complete setup',
          ),
        ],
      ),
    );
  }
}
