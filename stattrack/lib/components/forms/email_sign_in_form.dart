import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stattrack/components/buttons/main_button.dart';
import 'package:stattrack/components/forms/form_fields/bordered_text_input.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/utils/validator.dart';

/// Form displayed upon signing in with email
/// [auth] authentication repository
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

  bool _isLoading = false;
  bool _showInputErrors = false;
  String _authErrorMsg = '';
  bool _showAuthError = false;

  ///handles the submittion of form
  void _submit() async {
    setState(() {
      _showAuthError = false;
      _isLoading = true;
    });
    try {
      if (!_isValidEmail || _password.isEmpty) {
        throw Exception('Invalid inputs');
      }
      await widget.auth.signInWithEmailAndPassword(_email, _password);
      if (!mounted) return;
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      String error = '';
      switch (e.code) {
        case 'invalid-email':
          error = 'Invalid email';
          break;
        case 'wrong-password':
          error = 'Wrong password';
          break;
        case 'user-not-found':
          error = 'User was not found';
          break;
        case 'user-disabled':
          error = 'Looks like this user is disabled';
          break;
        default:
          error = 'Something went wront. Please try again';
          break;
      }
      setState(() {
        _showAuthError = true;
        _authErrorMsg = error;
      });
    } catch (e) {
      setState(() {
        _showInputErrors = true;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
    bool enableButton = !_isLoading;

    return Padding(
      padding: const EdgeInsets.all(31.0),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            BorderedTextInput(
              hintText: "...",
              titleText: "Email",
              key: const Key('emailSignInEmailTextFormField'),
              controller: _emailController,
              focusNode: _emailFocusNode,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onEditingComplete: _emailEditingComplete,
              onChanged: (email) => _updateState(),
            ),
            BorderedTextInput(
              obsucred: true,
              hintText: "...",
              titleText: "Password",
              key: const Key('emailSignInPasswordTextFormField'),
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              textInputAction: TextInputAction.done,
              onEditingComplete: _password.isNotEmpty ? _submit : null,
              onChanged: (password) => _updateState(),
            ),
            const SizedBox(
              height: 39.0,
            ),
            MainButton(
              key: const Key('emailSignInFormButton'),
              callback: enableButton ? _submit : null,
              label: 'Sign In',
            ),
            Column(
              children: _showAuthError
                  ? <Widget>[
                      const SizedBox(
                        height: 25.0,
                      ),
                      Text(
                        _showAuthError ? _authErrorMsg : '',
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 14.0,
                        ),
                      ),
                    ]
                  : [],
            ),
          ],
        ),
      ),
    );
  }
}
