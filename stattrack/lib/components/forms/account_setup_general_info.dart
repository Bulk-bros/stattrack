import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stattrack/components/buttons/main_button.dart';
import 'package:stattrack/components/forms/form_fields/bordered_text_input.dart';
import 'package:stattrack/components/forms/form_fields/image_picker_input.dart';
import 'package:stattrack/styles/font_styles.dart';
import 'package:stattrack/utils/validator.dart';

// TODO: Check that keyboard navigation work, and that correct keyboard type is displayed
class AccountSetupGeneralInfo extends StatefulWidget {
  const AccountSetupGeneralInfo({
    Key? key,
    required this.onComplete,
  }) : super(key: key);

  final void Function(String, String, num, num, File?) onComplete;

  @override
  _AccountSetupGeneralInfoState createState() =>
      _AccountSetupGeneralInfoState();
}

class _AccountSetupGeneralInfoState extends State<AccountSetupGeneralInfo> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _birthFocusNode = FocusNode();
  final FocusNode _heightFocusNode = FocusNode();
  final FocusNode _weightFocusNode = FocusNode();

  String get _name => _nameController.text;
  String get _birth => _birthController.text;
  String get _height => _heightController.text;
  String get _weight => _weightController.text;

  bool get _isValidName => Validator.isValidName(_name);
  bool get _isValidBirth => Validator.isValidBirthday(_birth);
  bool get _isValidHeight => Validator.isPositiveFloat(_height);
  bool get _isValidWeight => Validator.isPositiveFloat(_weight);

  XFile? _image;

  bool _showError = false;

  void _nameEditingComplete() {
    final newFocus = _isValidName ? _birthFocusNode : _nameFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _birthEditingComplete() {
    final newFocus = _isValidBirth ? _heightFocusNode : _birthFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _heightEditingComplete() {
    final newFocus = _isValidHeight ? _weightFocusNode : _heightFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _submit() {
    if (!_isValidName || !_isValidBirth || !_isValidHeight || !_isValidWeight) {
      setState(() {
        _showError = true;
      });
    } else {
      File? image;
      if (_image != null) {
        image = File(_image!.path);
      }
      widget.onComplete(
          _name, _birth, num.parse(_height), num.parse(_weight), image);
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
            'To get you up and running we need some information to calculate your daily consumptions. Let\'s start basic with some general informaiton:',
            style: TextStyle(
              fontWeight: FontStyles.fwTitle,
            ),
          ),
          const SizedBox(
            height: 25.0,
          ),
          _buildInput(
            label: 'Name',
            hint: 'Your full name',
            errorText: _showError && !_isValidName ? 'Cannot be empty' : null,
            controller: _nameController,
            focusNode: _nameFocusNode,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.name,
            onEditingComplete: _nameEditingComplete,
          ),
          _buildInput(
            label: 'Birthday',
            errorText: _showError && !_isValidBirth
                ? 'Make sure it\'s valid format (dd.mm.yyyy)'
                : null,
            hint: 'Your date of birth',
            controller: _birthController,
            focusNode: _birthFocusNode,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.datetime,
            onEditingComplete: _birthEditingComplete,
          ),
          _buildInput(
            label: 'Height',
            hint: 'Your height in cm',
            errorText: _showError && !_isValidHeight
                ? 'Only decimal numbers. Use "." instead of ","'
                : null,
            controller: _heightController,
            focusNode: _heightFocusNode,
            textInputAction: TextInputAction.next,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
            onEditingComplete: _heightEditingComplete,
          ),
          _buildInput(
            label: 'Weight',
            hint: 'Your weight in kg',
            errorText: _showError && !_isValidWeight
                ? 'Only decimal numbers. Use "." instead of ","'
                : null,
            controller: _weightController,
            focusNode: _weightFocusNode,
            textInputAction: TextInputAction.done,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
            onEditingComplete: _submit,
          ),
          const Text(
            'Image (Optional)',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontStyles.fwTitle,
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          ImagePickerInput(
            label: 'Upload profile picture',
            onImagePicked: (image) => setState(() {
              _image = image;
            }),
          ),
          const SizedBox(
            height: 20.0,
          ),
          MainButton(
            callback: _submit,
            label: 'Next',
          ),
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
