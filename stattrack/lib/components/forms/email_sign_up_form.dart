import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:stattrack/components/buttons/main_button.dart';
import 'package:stattrack/pages/auth_pages/terms_of_service_page.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/utils/validator.dart';

class EmailSignUpForm extends StatefulWidget {
  const EmailSignUpForm({Key? key, required this.auth}) : super(key: key);

  final AuthBase auth;

  @override
  State<EmailSignUpForm> createState() => _EmailSignUpFormState();
}

class _EmailSignUpFormState extends State<EmailSignUpForm> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _passwordConfirmFocusNode = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  String get _passwordConfirm => _passwordConfirmController.text;

  bool get _isValidEmail => Validator.isValidEmail(_email);
  bool get _isValidPassword => Validator.isValidPassword(_password);
  bool get _isValidPasswordConfirm =>
      Validator.isValidPassword(_passwordConfirm) &&
      _password == _passwordConfirm;

  bool _isChecked = false;

  bool _isLoading = false;
  bool _showInputErrors = false;
  bool _showAuthError = false;
  String _authErrorMsg = '';

  /// Handles the submition of form
  void _submit() async {
    setState(() {
      _showAuthError = false;
      _isLoading = true;
    });
    try {
      if (!_isValidEmail || !_isValidPassword || !_isValidPasswordConfirm) {
        throw Exception('Invalid inputs');
      }
      if (!_isChecked) {
        throw Exception('unchecked-checkbox');
      }
      await widget.auth.createUserWithEmailAndPassword(_email, _password);
      if (!mounted) return;
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      String error = '';
      switch (e.code) {
        case 'email-already-in-use':
          error = 'Email is already in use';
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
      if (e.toString() == 'Exception: unchecked-checkbox') {
        setState(() {
          _showAuthError = true;
          _authErrorMsg =
              'Please read and agree to out terms of service before signing up';
        });
      } else {
        setState(() {
          _showInputErrors = true;
        });
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateState() {
    setState(() {});
  }

  void _emailEditingComplete() {
    final newFocus = _isValidEmail ? _passwordFocusNode : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _passwordEditingComplete() {
    final newFocus =
        _isValidPassword ? _passwordConfirmFocusNode : _passwordFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  @override
  Widget build(BuildContext context) {
    // Makes sure submit button is only enabled
    // when all criterias are met
    bool enableSubmit = !_isLoading;

    return Padding(
      padding: const EdgeInsets.all(31.0),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              key: const Key('emailSignUpEmailTextFormField'),
              controller: _emailController,
              focusNode: _emailFocusNode,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Your email address',
                errorText:
                    _showInputErrors && !_isValidEmail ? 'Invalid email' : null,
              ),
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onEditingComplete: _emailEditingComplete,
              onChanged: (email) => _updateState(),
            ),
            TextFormField(
              key: const Key('emailSignUpPasswordTextFormField'),
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Your password',
                errorText: _showInputErrors && !_isValidPassword
                    ? '8-20 characters, lower and uppercase, \natleast one number and one symbol'
                    : null,
              ),
              obscureText: true,
              textInputAction: TextInputAction.next,
              onEditingComplete: _passwordEditingComplete,
              onChanged: (pwd) => _updateState(),
            ),
            TextFormField(
              key: const Key('emailSignUpPasswordConfirmTextFormField'),
              controller: _passwordConfirmController,
              focusNode: _passwordConfirmFocusNode,
              decoration: InputDecoration(
                labelText: 'Confirm password',
                hintText: 'Confirm password',
                errorText: _showInputErrors && !_isValidPasswordConfirm
                    ? 'Both passwords must match'
                    : null,
              ),
              obscureText: true,
              textInputAction: TextInputAction.done,
              onEditingComplete: _submit,
              onChanged: (pwdConfirm) => _updateState(),
            ),
            const SizedBox(
              height: 39.0,
            ),
            Row(
              children: <Widget>[
                Checkbox(
                  key: const Key('emailSignUpCheckbox'),
                  value: _isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked = value!;
                    });
                  },
                ),
                TextButton(
                  onPressed: () => Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: TermsOfServicePage(
                        onAccept: () => setState(() {
                          _isChecked = true;
                          Navigator.of(context).pop();
                        }),
                      ),
                    ),
                  ),
                  child: const Text(
                    'I have read and agree with the \nTerms of Service',
                    style: TextStyle(
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 39.0,
            ),
            MainButton(
              key: const Key('emailSignUpFormButton'),
              onPressed: enableSubmit ? _submit : null,
              label: 'Sign Up',
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
