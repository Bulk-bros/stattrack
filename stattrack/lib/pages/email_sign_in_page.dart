import 'package:flutter/material.dart';
import 'package:stattrack/components/CustomAppBar.dart';
import 'package:stattrack/components/forms/EmailSignInForm.dart';
import 'package:stattrack/components/forms/EmailSignUpForm.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/styles/palette.dart';

class EmailSignInPage extends StatefulWidget {
  const EmailSignInPage({Key? key, required this.auth}) : super(key: key);

  final AuthBase auth;

  @override
  _EmailSignInPageState createState() => _EmailSignInPageState();
}

class _EmailSignInPageState extends State<EmailSignInPage> {
  bool showSignUpForm = false;

  void _toggleForm() {
    setState(() {
      showSignUpForm = !showSignUpForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        headerTitle: showSignUpForm ? 'Sign Up' : 'Sign In',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            showSignUpForm
                ? EmailSignUpForm(auth: widget.auth)
                : EmailSignInForm(auth: widget.auth),
            TextButton(
              onPressed: _toggleForm,
              style: TextButton.styleFrom(primary: Palette.accent[400]),
              child: Text(
                showSignUpForm
                    ? 'Don\'t have account? Sign up here'
                    : 'Already have an account? Sign in here',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
