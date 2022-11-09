import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stattrack/components/buttons/form_button.dart';
import 'package:stattrack/components/custom_app_bar.dart';
import 'package:stattrack/models/user.dart';
import 'package:stattrack/providers/auth_provider.dart';
import 'package:stattrack/providers/repository_provider.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/services/repository.dart';
import 'package:stattrack/styles/palette.dart';
import 'package:stattrack/utils/validator.dart';
import 'package:intl/intl.dart';

class AccountSetupPage extends ConsumerStatefulWidget {
  const AccountSetupPage({Key? key}) : super(key: key);

  @override
  _AccountSetupPageState createState() => _AccountSetupPageState();
}

class _AccountSetupPageState extends ConsumerState<AccountSetupPage> {
  // Variables for all focus noded
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _birthdayFocusNode = FocusNode();
  final FocusNode _heightFocusNode = FocusNode();
  final FocusNode _weightFocusNode = FocusNode();
  final FocusNode _calorieFocusNode = FocusNode();
  final FocusNode _proteinFocusNode = FocusNode();
  final FocusNode _fatFocusNode = FocusNode();

  // Variables for all controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _calorieController = TextEditingController();
  final TextEditingController _proteinController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();

  // Getters for all input fields
  String get _name => _nameController.text;
  String get _birthday => _birthdayController.text;
  String get _height => _heightController.text;
  String get _weight => _weightController.text;
  String get _calorie => _calorieController.text;
  String get _protein => _proteinController.text;
  String get _fat => _fatController.text;

  // Getters for checking if input fields are valid
  bool get _isValidName => Validator.isValidName(_name);
  bool get _isValidBirthday => Validator.isValidBirthday(_birthday);
  bool get _isValidHeight => Validator.isPositiveFloat(_height);
  bool get _isValidWeight => Validator.isPositiveFloat(_weight);
  bool get _isValidCalorie => Validator.isPositiveFloat(_calorie);
  bool get _isValidProtein => Validator.isPositiveFloat(_protein);
  bool get _isValidFat => Validator.isPositiveFloat(_fat);

  // State variables
  bool _isLoading = false;
  bool _showInputErrors = false;

  void _updateState() {
    setState(() {});
  }

  /// Checks if you can go to next input field
  void _nameEditingComplete() {
    final newFocus = _isValidName ? _birthdayFocusNode : _nameFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  /// Checks if you can go to next input field
  void _birthdayEditingComplete() {
    final newFocus = _isValidBirthday ? _heightFocusNode : _birthdayFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  /// Checks if you can go to next input field
  void _heightEditingComplete() {
    final newFocus = _isValidHeight ? _weightFocusNode : _heightFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  /// Checks if you can go to next input field
  void _weightEditingComplete() {
    final newFocus = _isValidWeight ? _calorieFocusNode : _weightFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  /// Checks if you can go to next input field
  void _calorieEditingComplete() {
    final newFocus = _isValidCalorie ? _proteinFocusNode : _calorieFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  /// Checks if you can go to next input field
  void _proteinEditingComplete() {
    final newFocus = _isValidProtein ? _fatFocusNode : _proteinFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  /// Submits the setup form/sends request for saving user
  /// data to database
  void _submit() async {
    setState(() {
      _isLoading = true;
    });
    try {
      if (!_isValidName ||
          !_isValidBirthday ||
          !_isValidHeight ||
          !_isValidWeight ||
          !_isValidCalorie ||
          !_isValidProtein ||
          !_isValidFat) {
        throw Exception('Invalid inputs');
      }
      final AuthBase auth = ref.read(authProvider);
      final Repository repo = ref.read(repositoryProvider);

      // Convert string to timestamp
      final formatter = DateFormat('dd.MM.yyyy');
      final parsedBirthday = Timestamp.fromDate(formatter.parse(_birthday));

      repo.addUser(
          User(
            name: _name,
            birthday: parsedBirthday,
            height: num.parse(_height),
            weight: num.parse(_weight),
            dailyCalories: num.parse(_calorie),
            dailyProteins: num.parse(_protein),
            dailyFat: num.parse(_fat),
          ),
          auth.currentUser!.uid);
    } catch (e) {
      if (e.toString() == 'Exception: Invalid inputs') {
        setState(() {
          _showInputErrors = true;
        });
      }
      print(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Cancels the setup process by signing out the user
  void _signOut() {
    final AuthBase auth = ref.read(authProvider);
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CustomAppBar(headerTitle: 'Account Setup', actions: _buildActions()),
      body: SingleChildScrollView(
        child: _buildBody(context),
      ),
    );
  }

  /// Builds the cancel button
  List<Widget> _buildActions() {
    return <Widget>[
      TextButton(
        onPressed: _signOut,
        style: TextButton.styleFrom(primary: Palette.accent[400]),
        child: const Text(
          "Cancel",
        ),
      ),
    ];
  }

  /// Builds the form
  Widget _buildBody(BuildContext context) {
    bool enableSubmit = !_isLoading;

    return Padding(
      padding: const EdgeInsets.all(31.0),
      child: Form(
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              focusNode: _nameFocusNode,
              decoration: InputDecoration(
                labelText: 'Full name',
                hintText: 'Your full name',
                errorText: _showInputErrors && !_isValidName
                    ? 'Empty name not allowed'
                    : null,
              ),
              textInputAction: TextInputAction.next,
              onEditingComplete: _nameEditingComplete,
              onChanged: (name) => _updateState(),
            ),
            TextFormField(
              controller: _birthdayController,
              focusNode: _birthdayFocusNode,
              decoration: InputDecoration(
                labelText: 'Birthday',
                hintText: 'Your birthday',
                errorText: _showInputErrors && !_isValidBirthday
                    ? 'Make sure it`s a valid date'
                    : null,
              ),
              keyboardType: TextInputType.datetime,
              textInputAction: TextInputAction.next,
              onEditingComplete: _birthdayEditingComplete,
              onChanged: (name) => _updateState(),
            ),
            TextFormField(
              controller: _heightController,
              focusNode: _heightFocusNode,
              decoration: InputDecoration(
                labelText: 'Height (cm)',
                hintText: 'Your height (cm)',
                errorText: _showInputErrors && !_isValidHeight
                    ? 'Need to specify height'
                    : null,
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onEditingComplete: _heightEditingComplete,
              onChanged: (name) => _updateState(),
            ),
            TextFormField(
              controller: _weightController,
              focusNode: _weightFocusNode,
              decoration: InputDecoration(
                labelText: 'Weight (kg)',
                hintText: 'Your current weight (kg)',
                errorText: _showInputErrors && !_isValidWeight
                    ? 'Need to specify weight'
                    : null,
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onEditingComplete: _weightEditingComplete,
              onChanged: (name) => _updateState(),
            ),
            const SizedBox(
              height: 39.9,
            ),
            TextFormField(
              controller: _calorieController,
              focusNode: _calorieFocusNode,
              decoration: InputDecoration(
                labelText: 'Daily Calories',
                hintText: 'Your daily calorie consumption',
                errorText: _showInputErrors && !_isValidCalorie
                    ? 'Need to specify daily calorie consumption'
                    : null,
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onEditingComplete: _calorieEditingComplete,
              onChanged: (name) => _updateState(),
            ),
            TextFormField(
              controller: _proteinController,
              focusNode: _proteinFocusNode,
              decoration: InputDecoration(
                labelText: 'Daily Protein',
                hintText: 'Your daily protein consumption',
                errorText: _showInputErrors && !_isValidProtein
                    ? 'Need to specify daily protein consumption'
                    : null,
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onEditingComplete: _proteinEditingComplete,
              onChanged: (name) => _updateState(),
            ),
            TextFormField(
              controller: _fatController,
              focusNode: _fatFocusNode,
              decoration: InputDecoration(
                labelText: 'Daily Fat',
                hintText: 'Your daily fat consumption',
                errorText: _showInputErrors && !_isValidFat
                    ? 'Need to specify your daily fat consumption'
                    : null,
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              onEditingComplete: _submit,
              onChanged: (name) => _updateState(),
            ),
            const SizedBox(
              height: 39.0,
            ),
            FormButton(
              onPressed: enableSubmit ? _submit : null,
              label: 'Finish setup',
            ),
          ],
        ),
      ),
    );
  }
}
