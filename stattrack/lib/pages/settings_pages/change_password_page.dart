import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stattrack/components/buttons/main_button.dart';
import 'package:stattrack/components/app/custom_app_bar.dart';
import 'package:stattrack/providers/auth_provider.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/utils/validator.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final FocusNode _oldPwdNode = FocusNode();
  final FocusNode _newPwdNode = FocusNode();
  final FocusNode _newPwdConfirmNode = FocusNode();

  final TextEditingController _oldPwdController = TextEditingController();
  final TextEditingController _newPwdController = TextEditingController();
  final TextEditingController _newPwdConfirmController =
      TextEditingController();

  String get _oldPwd => _oldPwdController.text;
  String get _newPwd => _newPwdController.text;
  String get _newPwdConfirm => _newPwdConfirmController.text;

  bool get _isValidPassword => Validator.isValidPassword(_newPwd);

  bool _isLoading = false;
  bool _showInputErrors = false;
  String _authErrorMsg = '';
  bool _showAuthError = false;

  /// Handles the event of submitting change password form
  ///
  /// [context] the current build context the page is built ontop
  /// [auth] reference to auth repo.
  void _handleSubmit(BuildContext context, AuthBase auth) async {
    setState(() {
      _showAuthError = false;
      _isLoading = true;
    });
    try {
      if (!_isValidPassword) {
        throw Exception('Invalid new password');
      }
      if (_newPwd != _newPwdConfirm) {
        throw Exception('Password missmatch');
      }
      await auth.changePassword(_oldPwd, _newPwd);
      // Pop page
      if (!mounted) return;
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String error = '';
      switch (e.code) {
        case 'too-many-requests':
          error =
              'Access to this account has been temporarly disabled due to many failed login attempts.';
          break;
        case 'wrong-password':
          error = 'Wrong password. Please try again';
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

  /// Updates the state of the widget
  void _updateState() {
    setState(() {});
  }

  /// Methods for changing focus state of input fields
  void _oldPwdComplete() {
    final newFocus = _oldPwd.isEmpty ? _oldPwdNode : _newPwdNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _newPwdComplete() {
    final newFocus = _isValidPassword ? _newPwdConfirmNode : _newPwdNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  @override
  Widget build(BuildContext context) {
    final AuthBase auth = ref.read(authProvider);

    return Scaffold(
      appBar: const CustomAppBar(
        headerTitle: 'Change Password',
      ),
      body: _buildForm(context, auth),
    );
  }

  Widget _buildForm(BuildContext context, AuthBase auth) {
    return Padding(
      padding: const EdgeInsets.all(31.0),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _oldPwdController,
              focusNode: _oldPwdNode,
              decoration: InputDecoration(
                labelText: 'Current password',
                hintText: 'Your current password',
                errorText: _showInputErrors && _oldPwd.isEmpty
                    ? 'Cannot be empty'
                    : null,
              ),
              obscureText: true,
              textInputAction: TextInputAction.next,
              onEditingComplete: _oldPwdComplete,
              onChanged: (pwd) => _updateState(),
            ),
            TextFormField(
              controller: _newPwdController,
              focusNode: _newPwdNode,
              decoration: InputDecoration(
                labelText: 'New password',
                hintText: 'Your new password',
                errorText: _showInputErrors && !_isValidPassword
                    ? '8-20 characters, both lower and uppercase and atleast one number'
                    : null,
              ),
              obscureText: true,
              textInputAction: TextInputAction.next,
              onEditingComplete: _newPwdComplete,
              onChanged: (pwd) => _updateState(),
            ),
            TextFormField(
              controller: _newPwdConfirmController,
              focusNode: _newPwdConfirmNode,
              decoration: InputDecoration(
                labelText: 'Confirm new password',
                hintText: 'Confirm your new password',
                errorText: _showInputErrors && _newPwd != _newPwdConfirm
                    ? 'Both new passwords must match'
                    : null,
              ),
              obscureText: true,
              textInputAction: TextInputAction.done,
              onEditingComplete: () => _handleSubmit(context, auth),
              onChanged: (pwd) => _updateState(),
            ),
            const SizedBox(
              height: 31.0,
            ),
            MainButton(
              callback: !_isLoading ? () => _handleSubmit(context, auth) : null,
              label: "Change Password",
            ),
            const SizedBox(
              height: 31.0,
            ),
            Text(
              _showAuthError ? _authErrorMsg : '',
              style: const TextStyle(
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
