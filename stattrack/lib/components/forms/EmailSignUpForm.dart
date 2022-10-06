import 'package:flutter/material.dart';
import 'package:stattrack/components/buttons/form_button.dart';
import 'package:stattrack/services/auth.dart';

class EmailSignUpForm extends StatefulWidget {
  const EmailSignUpForm({Key? key, required this.auth}) : super(key: key);

  final AuthBase auth;

  @override
  _EmailSignUpFormState createState() => _EmailSignUpFormState();
}

class _EmailSignUpFormState extends State<EmailSignUpForm> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(31.0),
      child: Form(
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Full name',
                hintText: 'Your username',
              ),
            ),
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
            Row(
              children: <Widget>[
                Checkbox(
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                ),
                const Text('I have read and agree with the Terms of Service'),
              ],
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
  }
}
