import 'package:flutter/material.dart';
import 'package:stattrack/components/buttons/main_button.dart';
import 'package:stattrack/components/forms/form_fields/bordered_text_input.dart';
import 'package:stattrack/styles/font_styles.dart';
import 'package:stattrack/utils/validator.dart';

class AccountSetupPro extends StatefulWidget {
  const AccountSetupPro({Key? key, required this.onComplete}) : super(key: key);

  final Future<void> Function(num, num, num, num) onComplete;

  @override
  _AccountSetupProState createState() => _AccountSetupProState();
}

class _AccountSetupProState extends State<AccountSetupPro> {
  final TextEditingController _calorieController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();

  final FocusNode _calorieFocusNode = FocusNode();
  final FocusNode _proteinFocusNode = FocusNode();
  final FocusNode _carbsFocusNode = FocusNode();
  final FocusNode _fatFocusNode = FocusNode();

  String get _calories => _calorieController.text;
  String get _proteins => _proteinController.text;
  String get _carbs => _carbsController.text;
  String get _fat => _fatController.text;

  bool get _isValidCalorie => Validator.isPositiveFloat(_calories);
  bool get _isValidProtein => Validator.isPositiveFloat(_proteins);
  bool get _isValidCarbs => Validator.isPositiveFloat(_carbs);
  bool get _isValidFat => Validator.isPositiveFloat(_fat);

  bool _showError = false;
  bool _isLoading = false;

  void _calorieEditingComplete() {
    final newFocus = _isValidCalorie ? _proteinFocusNode : _calorieFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _proteinEditingComplete() {
    final newFocus = _isValidProtein ? _carbsFocusNode : _proteinFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _carbsEditingComplete() {
    final newFocus = _isValidCarbs ? _fatFocusNode : _carbsFocusNode;
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Text(
            'Enter the values you need to reach your goal!',
            style: TextStyle(fontWeight: FontStyles.fwTitle),
          ),
          const SizedBox(
            height: 25.0,
          ),
          _buildInput(
            label: 'Calorie consumption',
            hint: 'Daily calorie consumption',
            errorText: _showError && !_isValidCalorie
                ? 'Only decimal numbers. Use "." instead of ","'
                : null,
            controller: _calorieController,
            focusNode: _calorieFocusNode,
            textInputAction: TextInputAction.next,
            keyboardType: const TextInputType.numberWithOptions(
                decimal: true, signed: true),
            onEditingComplete: _calorieEditingComplete,
          ),
          _buildInput(
            label: 'Protein consumption',
            hint: 'Daily protein consumption',
            errorText: _showError && !_isValidProtein
                ? 'Only decimal numbers. Use "." instead of ","'
                : null,
            controller: _proteinController,
            focusNode: _proteinFocusNode,
            textInputAction: TextInputAction.next,
            keyboardType: const TextInputType.numberWithOptions(
                decimal: true, signed: true),
            onEditingComplete: _proteinEditingComplete,
          ),
          _buildInput(
            label: 'Carbs consumption',
            hint: 'Daily carbs consumption',
            errorText: _showError && !_isValidCarbs
                ? 'Only decimal numbers. Use "." instead of ","'
                : null,
            controller: _carbsController,
            focusNode: _carbsFocusNode,
            textInputAction: TextInputAction.next,
            keyboardType: const TextInputType.numberWithOptions(
                decimal: true, signed: true),
            onEditingComplete: _carbsEditingComplete,
          ),
          _buildInput(
            label: 'Fat consumption',
            hint: 'Daily fat consumption',
            errorText: _showError && !_isValidFat
                ? 'Only decimal numbers. Use "." instead of ","'
                : null,
            controller: _fatController,
            focusNode: _fatFocusNode,
            textInputAction: TextInputAction.next,
            keyboardType: const TextInputType.numberWithOptions(
                decimal: true, signed: true),
            onEditingComplete: _submit,
          ),
          const SizedBox(
            height: 20.0,
          ),
          MainButton(
            callback: _isLoading ? null : _submit,
            label: 'Complete setup',
          )
        ],
      ),
    );
  }

  Widget _buildInput({
    required String label,
    required String hint,
    String? errorText,
    required TextEditingController controller,
    required FocusNode focusNode,
    required TextInputAction textInputAction,
    required TextInputType keyboardType,
    required void Function() onEditingComplete,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontStyles.fwTitle,
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        BorderedTextInput(
          hintText: hint,
          errorText: errorText,
          controller: controller,
          focusNode: focusNode,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
          onEditingComplete: onEditingComplete,
          onChanged: (value) => _updateState(),
        ),
        const SizedBox(
          height: 16.0,
        ),
      ],
    );
  }
}
