import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:stattrack/components/buttons/secondary_button.dart';
import 'package:stattrack/components/custom_app_bar.dart';
import 'package:stattrack/components/buttons/main_button.dart';
import 'package:stattrack/components/forms/form_fields/image_picker_input.dart';
import 'package:stattrack/pages/settings_pages/change_password_page.dart';
import 'package:stattrack/providers/repository_provider.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/services/repository.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key, required this.auth}) : super(key: key);

  final AuthBase auth;

  void _signOut(BuildContext context) {
    auth.signOut();
    Navigator.pop(context);
  }

  void _handleChangePassword(BuildContext context) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.bottomToTop,
        child: const ChangePasswordPage(),
      ),
    );
  }

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CustomAppBar(
        headerTitle: "Settings",
      ),
      body: Padding(
        padding: const EdgeInsets.all(31.0),
        // Column separating all settings from logout button
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Column for all settings
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                ImagePickerInput(
                  onImagePicked: (image) => _uploadImage(context, ref, image),
                  label: 'Change profile image',
                ),
                const SizedBox(
                  height: 16.0,
                ),
                SecondaryButton(
                  callback: () => _handleChangePassword(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const <Widget>[
                      Text(
                        "Change password",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16.0,
                        ),
                      ),
                      Icon(Icons.edit, color: Colors.black87),
                    ],
                  ),
                ),
              ],
            ),
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
