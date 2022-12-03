import 'dart:io';

import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stattrack/components/buttons/main_button.dart';
import 'package:stattrack/components/forms/form_fields/bordered_text_input.dart';
import 'package:stattrack/components/forms/form_fields/image_picker_input.dart';
import 'package:stattrack/utils/validator.dart';

class CreateMealInfo extends StatefulWidget {
  const CreateMealInfo({Key? key, required this.onComplete}) : super(key: key);

  final void Function(String, File) onComplete;

  @override
  _CreateMealInfoState createState() => _CreateMealInfoState();
}

class _CreateMealInfoState extends State<CreateMealInfo> {
  final TextEditingController _nameController = TextEditingController();
  final CustomImageCropController _cropController = CustomImageCropController();

  String get _name => _nameController.text;
  XFile? _image;

  bool get _isValidName => Validator.isValidName(_name);

  bool _showError = false;

  void _updateImage(XFile img) {
    setState(() {
      _image = img;
    });
  }

  void _handleComplete() async {
    if (!_isValidName || _image == null) {
      setState(() {
        _showError = true;
      });
    } else {
      final imageData = await _cropController.onCropImage();

      File? image;
      XFile? file;
      if (imageData != null) {
        file = XFile.fromData(imageData.bytes);
        image = File(file.path);
      }

      print(image);
      print(file!.name);

      if (image != null) {
        widget.onComplete(_name, image);
      }
    }
  }

  void _updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        BorderedTextInput(
          titleText: 'Name:',
          hintText: 'Name',
          controller: _nameController,
          errorText: _showError && !_isValidName ? 'Cannot be empty' : null,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.name,
          onChanged: (value) => _updateState(),
        ),
        _image != null
            ? Expanded(
                child: CustomImageCrop(
                  cropController: _cropController,
                  image: FileImage(File(_image!.path)),
                ),
              )
            : const SizedBox(
                height: 0.0,
              ),
        const SizedBox(
          height: 16.0,
        ),
        ImagePickerInput(
          label: _image == null ? 'Upload image' : 'Change image',
          onImagePicked: (img) => _updateImage(img),
        ),
        const SizedBox(
          height: 16.0,
        ),
        MainButton(
          callback: _handleComplete,
          label: 'Next',
        ),
        _showError
            ? _buildError()
            : const SizedBox(
                height: 0,
              ),
      ],
    );
  }

  Widget _buildError() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        const SizedBox(
          height: 16.0,
        ),
        Text(
          _showError ? 'Make sure all fields are filled!' : '',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.red[700],
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }
}
