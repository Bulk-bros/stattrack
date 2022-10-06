import 'package:flutter/material.dart';
import 'package:stattrack/components/buttons/form_button.dart';
import 'package:stattrack/services/auth.dart';

class EmailSignInForm extends StatefulWidget {
  const EmailSignInForm({Key? key, required this.auth}) : super(key: key);

  final AuthBase auth;

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(31.0),
      child: Form(
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Your email address',
              ),
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Your password',
              ),
              obscureText: true,
            ),
            const SizedBox(
              height: 39.0,
            ),
            FormButton(
              onPressed: () {},
              label: 'Sign Up',
            ),
          ],
        ),
      ),
    );
    ;
  }
}
