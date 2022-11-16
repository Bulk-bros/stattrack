import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// A form field for selecting an image from the gallery
///
/// [label] a label for the image selector field. Set to `Pick image` by default
/// [onImagePicked] a callback function that is called when an image is picked
class ImagePickerInput extends StatelessWidget {
  const ImagePickerInput(
      {Key? key, this.label = 'Pick image', required this.onImagePicked})
      : super(key: key);

  final String label;
  final void Function(XFile) onImagePicked;

  /// Opens the gallery and allows the user to pick an image
  void _pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );

    if (image != null) {
      onImagePicked(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _pickImage(),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.all(20.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: RichText(
              overflow: TextOverflow.ellipsis,
              strutStyle: const StrutStyle(fontSize: 16.0),
              text: TextSpan(
                text: label,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16.0,
                ),
              ),
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
