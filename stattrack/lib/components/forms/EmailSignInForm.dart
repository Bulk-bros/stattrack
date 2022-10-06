import 'package:flutter/material.dart';
import 'package:stattrack/components/buttons/form_button.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/utils/validator.dart';

class EmailSignInForm extends StatefulWidget {
  const EmailSignInForm({Key? key, required this.auth}) : super(key: key);

  final AuthBase auth;

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  bool get _isValidEmail => Validator.isValidEmail(_email);

  bool _hasSubmitted = false;

  void _submit() {
    print('submitting');
    setState(() {
      _hasSubmitted = true;
    });
  }

  void _updateState() {
    setState(() {});
  }

  /// Handles the event when "next" is clicked on the keyboard
  /// If email is valid, focus net input field. Otherwise stay
  /// at current input field
  void _emailEditingComplete() {
    final newFocus = _isValidEmail ? _passwordFocusNode : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  @override
  Widget build(BuildContext context) {
    bool enableButton = _isValidEmail && _password.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(31.0),
      child: Form(
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              focusNode: _emailFocusNode,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Your email address',
                errorText:
                    _hasSubmitted && !_isValidEmail ? 'Invalid email' : null,
              ),
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onEditingComplete: _emailEditingComplete,
              onChanged: (email) => _updateState(),
            ),
            TextFormField(
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Your password',
                errorText: _hasSubmitted && _password.isEmpty
                    ? 'Password cannot be empty'
                    : null,
              ),
              obscureText: true,
              textInputAction: TextInputAction.done,
              onEditingComplete: _password.isNotEmpty ? _submit : null,
              onChanged: (password) => _updateState(),
            ),
            const SizedBox(
              height: 39.0,
            ),
            FormButton(
              onPressed: enableButton ? _submit : null,
              label: 'Sign Up',
            ),
          ],
        ),
      ),
    );
    ;
  }
}
