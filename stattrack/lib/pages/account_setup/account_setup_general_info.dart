import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stattrack/components/buttons/main_button.dart';
import 'package:stattrack/components/forms/form_fields/image_picker_input.dart';
import 'package:stattrack/components/forms/form_fields/stattrack_text_input.dart';
import 'package:stattrack/components/layout/spacing.dart';
import 'package:stattrack/components/layout/stattrack_column.dart';
import 'package:stattrack/styles/font_styles.dart';
import 'package:stattrack/utils/validator.dart';

class AccountSetupGeneralInfo extends StatefulWidget {
  const AccountSetupGeneralInfo({
    Key? key,
    required this.onComplete,
  }) : super(key: key);

  final void Function(String, DateTime, num, num, File?) onComplete;

  @override
  State<AccountSetupGeneralInfo> createState() =>
      _AccountSetupGeneralInfoState();
}

class _AccountSetupGeneralInfoState extends State<AccountSetupGeneralInfo> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _birthdayFocusNode = FocusNode();
  final FocusNode _heightFocusNode = FocusNode();
  final FocusNode _weightFocusNode = FocusNode();

  String get _name => _nameController.text;
  DateTime? _selectedBirthday;
  String get _height => _heightController.text;
  String get _weight => _weightController.text;

  bool get _isValidName => Validator.isValidName(_name);
  bool get _isValidHeight => Validator.isPositiveFloat(_height);
  bool get _isValidWeight => Validator.isPositiveFloat(_weight);

  XFile? _image;

  bool _showError = false;

  void _nameEditingComplete() {
    final newFocus = _isValidName ? _birthdayFocusNode : _nameFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _heightEditingComplete() {
    final newFocus = _isValidHeight ? _weightFocusNode : _heightFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _submit() {
    if (!_isValidName ||
        _selectedBirthday == null ||
        !_isValidHeight ||
        !_isValidWeight) {
      setState(() {
        _showError = true;
      });
    } else {
      File? image;
      if (_image != null) {
        image = File(_image!.path);
      }
      widget.onComplete(_name, _selectedBirthday!, num.parse(_height),
          num.parse(_weight), image);
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
          const Spacing(
            direction: 'y',
            amount: 'xl',
          ),
          StattrackColumn(
            gap: 'm',
            children: <Widget>[
              StattrackTextInput(
                label: 'Name',
                errorText:
                    _showError && !_isValidName ? 'Cannot be empty' : null,
                controller: _nameController,
                focusNode: _nameFocusNode,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                onEditingComplete: _nameEditingComplete,
                onChanged: (name) => _updateState(),
              ),
              _buildDatePicker(),
              StattrackTextInput(
                label: 'Height',
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
                onChanged: (height) => _updateState(),
              ),
              StattrackTextInput(
                label: 'Weight',
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
                onChanged: (weight) => _updateState(),
              ),
              const Text(
                'Image (Optional)',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontStyles.fwTitle,
                ),
              ),
              ImagePickerInput(
                label: 'Upload profile picture',
                onImagePicked: (image) => setState(() {
                  _image = image;
                }),
              ),
              MainButton(
                onPressed: _submit,
                label: 'Next',
              ),
            ],
          ),
        ],
      ),
    );
  }

  // TODO: Refactore into component
  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const Text(
          'Birthday',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontStyles.fwTitle,
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        TextButton(
          focusNode: _birthdayFocusNode,
          style: TextButton.styleFrom(
            side: BorderSide(
              color: _showError && _selectedBirthday == null
                  ? Colors.red[700]!
                  : Colors.black87,
              width: 1.0,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 22.0,
              horizontal: 14.0,
            ),
          ),
          onPressed: () {
            DatePicker.showDatePicker(
              context,
              showTitleActions: true,
              minTime: DateTime(1900, 1, 1),
              maxTime: DateTime.now(),
              onConfirm: (date) {
                setState(() {
                  _selectedBirthday = date;
                });
              },
              currentTime: DateTime.now(),
            );
          },
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _selectedBirthday == null
                  ? 'Your date of birth'
                  : '${_selectedBirthday!.day}.${_selectedBirthday!.month}.${_selectedBirthday!.year}',
              style: const TextStyle(
                color: Colors.black54,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        Text(
          _showError && _selectedBirthday == null
              ? '   Need to select a birthday'
              : '',
          style: TextStyle(
            color: Colors.red[700],
            fontSize: 12.0,
          ),
        ),
        SizedBox(
          height: _showError ? 16.0 : 0.0,
        ),
      ],
    );
  }
}
