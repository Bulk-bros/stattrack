import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stattrack/components/custom_app_bar.dart';
import 'package:stattrack/components/buttons/main_button.dart';
import 'package:stattrack/components/forms/form_fields/image_picker_input.dart';
import 'package:stattrack/providers/repository_provider.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/services/repository.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key, required this.auth}) : super(key: key);

  final AuthBase auth;

  void _uploadImage(BuildContext context, WidgetRef ref, XFile image) {
    final Repository repo = ref.read(repositoryProvider);
    try {
      repo.uploadProfilePicture(image, auth.currentUser!.uid);

      const snackBar = SnackBar(
        content: Text('Profile picture was succesfully changed!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      print(e.toString());
    }
  }

  void _signOut(BuildContext context) {
    auth.signOut();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CustomAppBar(
        headerTitle: "Settings",
      ),
      body: Padding(
        padding: const EdgeInsets.all(31.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ImagePickerInput(
              label: 'Change profile image',
              onImagePicked: (image) => _uploadImage(context, ref, image),
            ),
            // TODO: Add more settings options here
            const SizedBox(height: 39.9),
            MainButton(
              callback: () => _signOut(context),
              label: "Log out",
            ),
          ],
        ),
      ),
    );
  }
}
