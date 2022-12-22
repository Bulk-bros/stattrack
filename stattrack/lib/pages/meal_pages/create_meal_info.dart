import 'dart:io';
import 'dart:typed_data';

import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stattrack/components/buttons/main_button.dart';
import 'package:stattrack/components/forms/form_fields/image_picker_input.dart';
import 'package:stattrack/components/forms/form_fields/stattrack_text_input.dart';
import 'package:stattrack/styles/font_styles.dart';
import 'package:stattrack/styles/palette.dart';
import 'package:stattrack/utils/validator.dart';

class CreateMealInfo extends StatefulWidget {
  const CreateMealInfo(
      {Key? key, required this.navPrev, required this.onComplete})
      : super(key: key);

  final void Function() navPrev;
  final void Function(String, Uint8List?) onComplete;

  @override
  State<CreateMealInfo> createState() => _CreateMealInfoState();
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
    if (!_isValidName) {
      setState(() {
        _showError = true;
      });
    } else {
      MemoryImage? imageData;
      if (_image != null) {
        imageData = await _cropController.onCropImage();
      }

      Uint8List? imageBytes;
      if (imageData != null) {
        imageBytes = imageData.bytes;
      }

      widget.onComplete(_name, imageBytes);
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
        const SizedBox(
          height: 20.0,
        ),
        _buildHeader(),
        const SizedBox(
          height: 20.0,
        ),
        StattrackTextInput(
          label: 'Name:',
          controller: _nameController,
          errorText: _showError && !_isValidName ? 'Cannot be empty' : null,
          textInputAction: TextInputAction.done,
          onChanged: (value) => _updateState(),
        ),
        const SizedBox(
          height: 20.0,
        ),
        ImagePickerInput(
          label: _image == null ? 'Upload image' : 'Change image',
          onImagePicked: (img) => _updateImage(img),
        ),
        const SizedBox(
          height: 16.0,
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
        _showError
            ? _buildError()
            : const SizedBox(
                height: 0,
              ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: widget.navPrev,
          icon: const Icon(Icons.close),
        ),
        const Text(
          'Info',
          style: TextStyle(
            fontSize: FontStyles.fsTitle1,
            fontWeight: FontStyles.fwTitle,
          ),
        ),
        TextButton(
          onPressed: _handleComplete,
          child: Text(
            'Next',
            style: TextStyle(
              color: Palette.accent[400],
            ),
          ),
        )
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
