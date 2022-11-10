import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerInput extends StatefulWidget {
  const ImagePickerInput(
      {Key? key, this.label = 'Pick image', required this.onImagePicked})
      : super(key: key);

  final String label;
  final void Function(XFile) onImagePicked;

  @override
  _ImagePickerState createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePickerInput> {
  void _pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );

    if (image != null) {
      widget.onImagePicked(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => _pickImage(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            widget.label,
            style: const TextStyle(
              color: Colors.black87,
            ),
          ),
          const Icon(
            Icons.upload,
            color: Colors.black87,
          ),
        ],
      ),
    );
  }
}
