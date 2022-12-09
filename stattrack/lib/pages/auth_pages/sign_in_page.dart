import 'package:flutter/material.dart';
import 'package:stattrack/components/buttons/auth_button.dart';
import 'package:stattrack/components/app/custom_app_bar.dart';
import 'package:stattrack/components/buttons/stattrack_text_button.dart';
import 'package:stattrack/pages/auth_pages/email_sign_in_page.dart';
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
      appBar: const CustomAppBar(
        headerTitle: 'Stattrack',
        key: Key('signInPageTitle'),
      ),
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
            key: Key('signInPageLoginText'),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: FontStyles.fsTitle1,
              fontWeight: FontStyles.fwTitle,
            ),
          ),
          spacing,
          AuthButton(
            key: const Key('signInPageFacebookAuthButton'),
            label: 'Facebook',
            iconPath: 'assets/icons/square-facebook.svg',
            iconAlt: 'Facebook Logo',
            bgColor: Colors.blue,
            textColor: Colors.white,
            onPressed: _signInWithFacebook,
          ),
          spacing,
          AuthButton(
            key: const Key('signInPageGoogleAuthButton'),
            label: 'Google',
            iconPath: 'assets/icons/google.svg',
            iconAlt: 'Google Logo',
            bgColor: Colors.deepOrange[400],
            textColor: Colors.white,
            onPressed: _signInWithGoogle,
          ),
          spacing,
          AuthButton(
            key: const Key('signInPageEmailAuthButton'),
            label: 'Email',
            iconPath: 'assets/icons/envelope-solid.svg',
            iconAlt: 'Mail Icon',
            bgColor: Colors.white,
            textColor: Colors.black87,
            onPressed: () => _signInWithEmail(context, false),
          ),
          spacing,
          StattrackTextButton(
            key: const Key('signInPageSignUpButton'),
            onPressed: () => _signInWithEmail(context, true),
            label: "Don't have an account? Sign up here",
          )
        ],
      ),
    );
  }
}
