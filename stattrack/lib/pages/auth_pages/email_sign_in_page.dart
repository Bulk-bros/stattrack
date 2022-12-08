import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:stattrack/components/app/custom_app_bar.dart';
import 'package:stattrack/components/forms/email_sign_in_form.dart';
import 'package:stattrack/components/forms/email_sign_up_form.dart';
import 'package:stattrack/pages/auth_pages/forgot_password_page.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/styles/palette.dart';

class EmailSignInPage extends StatefulWidget {
  const EmailSignInPage({Key? key, required this.auth, this.showSignUp})
      : super(key: key);

  final AuthBase auth;
  final bool? showSignUp;

  @override
  State<EmailSignInPage> createState() => _EmailSignInPageState();
}

class _EmailSignInPageState extends State<EmailSignInPage> {
  late bool _showSignUpForm;

  @override
  void initState() {
    super.initState();
    _showSignUpForm = widget.showSignUp ?? false;
  }

  void _toggleForm() {
    setState(() {
      _showSignUpForm = !_showSignUpForm;
    });
  }

  void _handleForgotPassword(BuildContext context) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.bottomToTop,
        child: const ForgotPasswordPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        headerTitle: _showSignUpForm ? 'Sign Up' : 'Sign In',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _showSignUpForm
                ? EmailSignUpForm(auth: widget.auth)
                : EmailSignInForm(auth: widget.auth),
            TextButton(
              onPressed: _toggleForm,
              style: TextButton.styleFrom(foregroundColor: Palette.accent[400]),
              child: Text(
                _showSignUpForm
                    ? 'Already have an account? Sign in here'
                    : 'Don\'t have account? Sign up here',
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
            !_showSignUpForm
                ? TextButton(
                    onPressed: () => _handleForgotPassword(context),
                    style: TextButton.styleFrom(
                        foregroundColor: Palette.accent[400]),
                    child: const Text(
                      "Forgot password",
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
