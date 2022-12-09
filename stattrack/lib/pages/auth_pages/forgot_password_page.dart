import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stattrack/components/buttons/main_button.dart';
import 'package:stattrack/components/app/custom_app_bar.dart';
import 'package:stattrack/providers/auth_provider.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/utils/validator.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final FocusNode _emailFocusNode = FocusNode();

  final TextEditingController _emailController = TextEditingController();

  String get _email => _emailController.text;

  bool get _isValidEmail => Validator.isValidEmail(_email);

  bool _isLoading = false;
  bool _showInputErrors = false;
  String _authErrorMsg = '';
  bool _showAuthError = false;

  void _handleSubmit(BuildContext context, AuthBase auth) async {
    setState(() {
      _showAuthError = false;
      _isLoading = true;
    });
    try {
      if (!_isValidEmail) {
        throw Exception("Inalid email");
      }
      await auth.resetPassword(_email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reset password email sent!'),
        ),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String error = '';
      switch (e.code) {
        case 'user-not-found':
          error = 'No user found for that email.';
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

  @override
  Widget build(BuildContext context) {
    final AuthBase auth = ref.read(authProvider);

    return Scaffold(
      appBar: const CustomAppBar(
        headerTitle: 'Forgot Password',
      ),
      body: _buildBody(context, auth),
    );
  }

  Widget _buildBody(BuildContext context, AuthBase auth) {
    return Padding(
      padding: const EdgeInsets.all(31.0),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _emailController,
              focusNode: _emailFocusNode,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Email address to send reset mail to',
                errorText:
                    _showInputErrors && !_isValidEmail ? 'Invalid email' : null,
              ),
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              onEditingComplete: () => _handleSubmit(context, auth),
              onChanged: (email) => _updateState(),
            ),
            const SizedBox(
              height: 31.0,
            ),
            MainButton(
              onPressed:
                  !_isLoading ? () => _handleSubmit(context, auth) : null,
              label: "Send reset mail",
            ),
            const SizedBox(
              height: 31.0,
            ),
            Text(
              _showAuthError ? _authErrorMsg : '',
              style: const TextStyle(
                color: Colors.red,
                fontSize: 16.0,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
