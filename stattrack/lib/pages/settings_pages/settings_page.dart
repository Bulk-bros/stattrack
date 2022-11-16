import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:stattrack/components/custom_app_bar.dart';
import 'package:stattrack/components/buttons/main_button.dart';
import 'package:stattrack/pages/settings_pages/change_password_page.dart';
import 'package:stattrack/services/auth.dart';

class SettingsPage extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
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
                TextButton(
                  onPressed: () => _handleChangePassword(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const <Widget>[
                      Text(
                        "Change password",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20.0,
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
