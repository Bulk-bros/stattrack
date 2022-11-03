import 'package:flutter/material.dart';
import 'package:stattrack/components/CustomAppBar.dart';
import 'package:stattrack/components/buttons/auth_button.dart';
import 'package:stattrack/pages/email_sign_in_page.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/styles/font_styles.dart';
import 'package:stattrack/styles/palette.dart';

/// The signin page
class SignInPage extends StatelessWidget {
  const SignInPage({Key? key, required this.auth}) : super(key: key);

  final AuthBase auth;

  Future<void> _signInWithGoogle() async {
    try {
      await auth.signInWithGoogle();
    } catch (e) {
      // TODO: Handle google signin exceptions
      print(e.toString());
    }
  }

  Future<void> _signInWithFacebook() async {
    try {
      await auth.signInWithFacebook();
    } catch (e) {
      // TODO: Handle google signin exceptions
      print(e.toString());
    }
  }

  void _signInWithEmail(BuildContext context, bool showSignUp) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) =>
            EmailSignInPage(auth: auth, showSignUp: showSignUp),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(headerTitle: 'Stattrack'),
      body: _buildBody(context),
    );
  }

  // Returns the body of the sign in page
  Widget _buildBody(BuildContext context) {
    const spacing = SizedBox(height: 20.0);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Text(
            'Login',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: FontStyles.fsTitle1,
              fontWeight: FontStyles.fwTitle,
            ),
          ),
          spacing,
          AuthButton(
            label: 'Facebook',
            iconPath: 'assets/icons/square-facebook.svg',
            iconAlt: 'Facebook Logo',
            bgColor: Colors.blue,
            textColor: Colors.white,
            // TODO: implement action
            onPressed: _signInWithFacebook,
          ),
          spacing,
          AuthButton(
            label: 'Google',
            iconPath: 'assets/icons/google.svg',
            iconAlt: 'Google Logo',
            bgColor: Colors.deepOrange[400],
            textColor: Colors.white,
            // TODO: implement action
            onPressed: _signInWithGoogle,
          ),
          spacing,
          AuthButton(
            label: 'Email',
            iconPath: 'assets/icons/envelope-solid.svg',
            iconAlt: 'Mail Icon',
            bgColor: Colors.white,
            textColor: Colors.black87,
            // TODO: implement action
            onPressed: () => _signInWithEmail(context, false),
          ),
          spacing,
          TextButton(
            onPressed: () => _signInWithEmail(context, true),
            child: Text(
              "Don't have an account? Sign up here",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Palette.accent[200],
                fontSize: 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
