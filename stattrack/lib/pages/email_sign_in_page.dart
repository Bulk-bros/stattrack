import 'package:flutter/material.dart';
import 'package:stattrack/components/CustomAppBar.dart';
import 'package:stattrack/components/forms/EmailSignInForm.dart';
import 'package:stattrack/components/forms/EmailSignUpForm.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/styles/palette.dart';

class EmailSignInPage extends StatefulWidget {
  const EmailSignInPage({Key? key, required this.auth, this.showSignUp})
      : super(key: key);

  final AuthBase auth;
  final bool? showSignUp;

  @override
  _EmailSignInPageState createState() => _EmailSignInPageState();
}

class _EmailSignInPageState extends State<EmailSignInPage> {
  late bool _showSignUpForm;

  @override
  void initState() {
    _showSignUpForm = widget.showSignUp ?? false;
  }

  void _toggleForm() {
    setState(() {
      _showSignUpForm = !_showSignUpForm;
    });
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
              style: TextButton.styleFrom(primary: Palette.accent[400]),
              child: Text(
                _showSignUpForm
                    ? 'Already have an account? Sign in here'
                    : 'Don\'t have account? Sign up here',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
