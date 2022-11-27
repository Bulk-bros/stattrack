import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:stattrack/components/buttons/secondary_button.dart';
import 'package:stattrack/components/app/custom_app_bar.dart';
import 'package:stattrack/components/buttons/main_button.dart';
import 'package:stattrack/components/forms/form_fields/image_picker_input.dart';
import 'package:stattrack/pages/settings_pages/change_password_page.dart';
import 'package:stattrack/pages/user_profile_page.dart';
import 'package:stattrack/providers/repository_provider.dart';
import 'package:stattrack/services/api_paths.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/services/repository.dart';
import 'package:stattrack/styles/font_styles.dart';
import 'package:stattrack/styles/palette.dart';

enum UpdateAction {
  calories,
  proteins,
  fat,
  carbs,
  weight,
}

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

  void _uploadImage(BuildContext context, WidgetRef ref, XFile image) async {
    final Repository repo = ref.read(repositoryProvider);

    try {
      // Upload new image
      String imageUrl = await repo.uploadImage(
          image, ApiPaths.profilePicture(auth.currentUser!.uid));

      // Update the path stored in the user document
      repo.updateProfilePicturePath(auth.currentUser!.uid, imageUrl);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile picture was succesfully changed!'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not upload image. Please try again'),
        ),
      );
    }
  }

  Future<void> _showDialog({
    required BuildContext context,
    required WidgetRef ref,
    required UpdateAction updateAction,
    required String title,
    required String hint,
  }) {
    String inputValue = '';

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            onChanged: (value) => inputValue = value,
            decoration: InputDecoration(hintText: hint),
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Palette.accent[200],
              ),
              onPressed: () {
                try {
                  _handleUpdateAction(
                      context, ref, updateAction, num.parse(inputValue));
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Something went wrong. Please try again!'),
                    ),
                  );
                } finally {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Update'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black87,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _handleUpdateAction(BuildContext context, WidgetRef ref,
      UpdateAction updateAction, num value) {
    final String uid = auth.currentUser!.uid;
    final Repository repo = ref.read(repositoryProvider);

    switch (updateAction) {
      case UpdateAction.calories:
        repo.updateDailyCalorieConsumption(uid, value);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Daily calories consumption updated!'),
          ),
        );
        break;
      case UpdateAction.proteins:
        repo.updateDailyProteinConsumption(uid, value);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Daily proteins consumption updated!'),
          ),
        );
        break;
      case UpdateAction.carbs:
        repo.updateDailyCarbsConsumption(uid, value);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Daily carbs consumption updated!'),
          ),
        );
        break;
      case UpdateAction.fat:
        repo.updateDailyFatConsumption(uid, value);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Daily fat consumption updated!'),
          ),
        );
        break;
      case UpdateAction.weight:
        repo.updateWeight(uid, value);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Weight updated!'),
          ),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong. Please try again!'),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double spacing = 31.0;

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
                _buildProfileSettings(context, ref),
                SizedBox(
                  height: spacing,
                ),
                _buildConsumptionSettings(context, ref),
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

  Widget _buildProfileSettings(BuildContext context, WidgetRef ref) {
    double spacing = 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildSectionHeading('Profile settings'),
        SizedBox(
          height: spacing,
        ),
        ImagePickerInput(
          onImagePicked: (image) => _uploadImage(context, ref, image),
          label: 'Change profile image',
        ),
        SizedBox(
          height: spacing,
        ),
        _buildDialogButton(
          context: context,
          ref: ref,
          label: 'Update weight',
          dialogTitle: 'Update weight',
          dialogHint: 'New weight',
          updateAction: UpdateAction.weight,
        ),
        SizedBox(
          height: spacing,
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
    );
  }

  Widget _buildConsumptionSettings(BuildContext context, WidgetRef ref) {
    double spacing = 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildSectionHeading('Daily consumption settings'),
        SizedBox(
          height: spacing,
        ),
        _buildDialogButton(
          context: context,
          ref: ref,
          label: 'Calorie consumption',
          dialogTitle: 'Change daily calorie consumption',
          dialogHint: 'Daily calorie consumption',
          updateAction: UpdateAction.calories,
        ),
        SizedBox(
          height: spacing,
        ),
        _buildDialogButton(
          context: context,
          ref: ref,
          label: 'Protein consumption',
          dialogTitle: 'Change daily protein consumption',
          dialogHint: 'Daily protein consumption',
          updateAction: UpdateAction.proteins,
        ),
        SizedBox(
          height: spacing,
        ),
        _buildDialogButton(
          context: context,
          ref: ref,
          label: 'Carbs consumption',
          dialogTitle: 'Change daily carbs consumption',
          dialogHint: 'Daily carbs consumption',
          updateAction: UpdateAction.carbs,
        ),
        SizedBox(
          height: spacing,
        ),
        _buildDialogButton(
          context: context,
          ref: ref,
          label: 'Fat consumption',
          dialogTitle: 'Change daily fat consumption',
          dialogHint: 'Daily fat consumption',
          updateAction: UpdateAction.fat,
        ),
      ],
    );
  }

  Widget _buildSectionHeading(String heading) {
    return Text(
      heading,
      textAlign: TextAlign.left,
      style: const TextStyle(
        fontWeight: FontStyles.fwTitle,
        fontSize: FontStyles.fsBody,
      ),
    );
  }

  Widget _buildDialogButton({
    required BuildContext context,
    required WidgetRef ref,
    required String label,
    required String dialogTitle,
    required String dialogHint,
    required UpdateAction updateAction,
  }) {
    return SecondaryButton(
      callback: () => _showDialog(
        context: context,
        ref: ref,
        updateAction: updateAction,
        title: dialogTitle,
        hint: dialogHint,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16.0,
            ),
          ),
          const Icon(Icons.edit, color: Colors.black87),
        ],
      ),
    );
  }
}
