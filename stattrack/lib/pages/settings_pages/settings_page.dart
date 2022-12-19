import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:stattrack/components/buttons/secondary_button.dart';
import 'package:stattrack/components/app/custom_app_bar.dart';
import 'package:stattrack/components/buttons/main_button.dart';
import 'package:stattrack/components/forms/form_fields/image_picker_input.dart';
import 'package:stattrack/models/weight.dart';
import 'package:stattrack/pages/settings_pages/change_password_page.dart';
import 'package:stattrack/pages/settings_pages/profile_settings_page.dart';
import 'package:stattrack/providers/auth_provider.dart';
import 'package:stattrack/providers/user_service_provider.dart';
import 'package:stattrack/providers/weight_service_provider.dart';
import 'package:stattrack/services/user_service.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/services/weight_service.dart';
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
  const SettingsPage({Key? key, required this.auth, required this.userService})
      : super(key: key);

  final AuthBase auth;
  final UserService userService;

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
    final UserService userService = ref.read(userServiceProvider);

    try {
      await userService.updateUserProfilePicture(
          File(image.path), auth.currentUser!.uid);

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

  void _navigateToProfileSettings(BuildContext context) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: ProfileSettingsPage(
          auth: auth,
          userService: userService,
        ),
      ),
    );
  }

  void _handleUpdateAction(BuildContext context, WidgetRef ref,
      UpdateAction updateAction, num value) {
    final String uid = auth.currentUser!.uid;
    final WeightService weightService = ref.read(weightServiceProvider);
    final UserService userService = ref.read(userServiceProvider);

    switch (updateAction) {
      case UpdateAction.calories:
        userService.updateDailyCaloriConsumption(uid, value);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Daily calories consumption updated!'),
          ),
        );
        break;
      case UpdateAction.proteins:
        userService.updateDailyProteinConsumption(uid, value);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Daily proteins consumption updated!'),
          ),
        );
        break;
      case UpdateAction.carbs:
        userService.updateDailyCarbsConsumption(uid, value);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Daily carbs consumption updated!'),
          ),
        );
        break;
      case UpdateAction.fat:
        userService.updateDailyFatConsumption(uid, value);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Daily fat consumption updated!'),
          ),
        );
        break;
      case UpdateAction.weight:
        weightService.logWeight(
          Weight(value: value, time: Timestamp.now()),
          uid,
        );
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

  Future<void> _deleteAccount(BuildContext context, WidgetRef ref) {
    final AuthBase auth = ref.read(authProvider);
    final UserService userService = ref.read(userServiceProvider);

    return showDialog(
        context: context,
        builder: (c) {
          return AlertDialog(
            title: const Text('Delete account'),
            content: const Text(
              'Are you sure you want to delete your account? All your user data will be lost!',
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
                onPressed: () async {
                  try {
                    final User user = auth.currentUser!;
                    await userService.deleteUser(user.uid);
                    await auth.deleteUser(user);

                    Navigator.of(c).pop();
                    Navigator.of(context).pop();
                  } catch (e) {
                    Navigator.of(c).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Something went wrong. Please try again!',
                        ),
                      ),
                    );
                  }
                },
                child: const Text('Delete'),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black87,
                ),
                onPressed: () {
                  Navigator.of(c).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double spacing = 31.0;

    return Scaffold(
      appBar: const CustomAppBar(
        headerTitle: "Settings",
      ),
      body: Padding(
        padding: const EdgeInsets.all(31.0),
        // Column separating all settings from logout button
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Column for all settings
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildGeneralSettings(context, ref),
                  SizedBox(
                    height: spacing,
                  ),
                  _buildOtherOptions(context, ref),
                ],
              ),
              const SizedBox(
                height: 31.0,
              ),
              MainButton(
                callback: () => _signOut(context),
                label: "Log out",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGeneralSettings(BuildContext context, WidgetRef ref) {
    double spacing = 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildSectionHeading('General'),
        SizedBox(
          height: spacing,
        ),
        SecondaryButton(
          callback: () => _navigateToProfileSettings(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              Text(
                "Profile settings",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16.0,
                ),
              ),
              Icon(Icons.person, color: Colors.black87),
            ],
          ),
        ),
        SizedBox(
          height: spacing,
        ),
        SecondaryButton(
          callback: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              Text(
                "Change theme",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16.0,
                ),
              ),
              Icon(Icons.dark_mode, color: Colors.black87),
            ],
          ),
        ),
        SizedBox(
          height: spacing,
        ),
        SecondaryButton(
          callback: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Color theme",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(
                height: 20,
                width: 24,
                child: Container(
                  margin: const EdgeInsets.only(right: 4),
                  color: Palette.accent[400],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOtherOptions(BuildContext context, WidgetRef ref) {
    double spacing = 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildSectionHeading('Other options'),
        SizedBox(
          height: spacing,
        ),
        SecondaryButton(
          callback: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              Text(
                "Terms of Service",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16.0,
                ),
              ),
              Icon(Icons.menu_book, color: Colors.black87),
            ],
          ),
        ),
        SizedBox(
          height: spacing,
        ),
        SecondaryButton(
          callback: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              Text(
                "Privacy Policy",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16.0,
                ),
              ),
              Icon(Icons.fingerprint, color: Colors.black87),
            ],
          ),
        ),
        SizedBox(
          height: spacing,
        ),
        SecondaryButton(
          callback: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              Text(
                "Share Feedback",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16.0,
                ),
              ),
              Icon(Icons.feedback, color: Colors.black87),
            ],
          ),
        ),
        SizedBox(
          height: spacing,
        ),
        SecondaryButton(
          callback: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              Text(
                "Report a bug",
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 16.0,
                ),
              ),
              Icon(Icons.bug_report, color: Colors.black87),
            ],
          ),
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
