import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stattrack/components/app/custom_app_bar.dart';
import 'package:stattrack/components/buttons/main_button.dart';
import 'package:stattrack/models/ingredient.dart';
import 'package:stattrack/providers/auth_provider.dart';
import 'package:stattrack/providers/repository_provider.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/services/repository.dart';
import 'package:stattrack/utils/validator.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;

class CreateIngredientPage extends ConsumerStatefulWidget {
  const CreateIngredientPage({Key? key}) : super(key: key);

  @override
  _CreateIngredientPageState createState() => _CreateIngredientPageState();
}

class _CreateIngredientPageState extends ConsumerState<CreateIngredientPage> {
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _caloriesFocusNode = FocusNode();
  final FocusNode _proteinsFocusNode = FocusNode();
  final FocusNode _carbsFocusNode = FocusNode();
  final FocusNode _fatFocusNode = FocusNode();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _proteinsController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();

  String get _name => _nameController.text;
  String get _calories => _caloriesController.text;
  String get _proteins => _proteinsController.text;
  String get _carbs => _carbsController.text;
  String get _fat => _fatController.text;

  bool get _isValidName => _name.isNotEmpty;
  bool get _isValidCalories => Validator.isPositiveFloat(_calories);
  bool get _isValidProteins => Validator.isPositiveFloat(_proteins);
  bool get _isValidCarbs => Validator.isPositiveFloat(_carbs);
  bool get _isValidFat => Validator.isPositiveFloat(_fat);

  bool _showInputErrors = false;
  bool _isLoading = false;

  void _submit(AuthBase auth, Repository repo) async {
    setState(() {
      _isLoading = true;
    });
    try {
      if (!_isValidName ||
          !_isValidCalories ||
          !_isValidProteins ||
          !_isValidCarbs ||
          !_isValidFat) {
        throw Exception('Invalid inputs');
      }
      await repo.addIngredient(
          Ingredient(
            name: _name,
            caloriesPer100g: num.parse(_calories),
            proteinsPer100g: num.parse(_proteins),
            fatPer100g: num.parse(_fat),
            carbsPer100g: num.parse(_carbs),
          ),
          auth.currentUser!.uid);
      if (!mounted) return;
      Navigator.pop(context);
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

  void _nameEditingComplete() {
    final newFocus = _isValidName ? _caloriesFocusNode : _nameFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _caloriesEditingComplete() {
    final newFocus = _isValidCalories ? _proteinsFocusNode : _caloriesFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _proteinsEditingComplete() {
    final newFocus = _isValidProteins ? _carbsFocusNode : _proteinsFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _carbsEditingComplete() {
    final newFocus = _isValidCarbs ? _fatFocusNode : _carbsFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        headerTitle: 'Create Ingredient',
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final AuthBase auth = ref.read(authProvider);
    final Repository repo = ref.read(repositoryProvider);

    return Padding(
      padding: const EdgeInsets.all(31.0),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              focusNode: _nameFocusNode,
              decoration: InputDecoration(
                hintText: 'Ingredient name',
                errorText: _showInputErrors && !_isValidName
                    ? 'Cannot be empty'
                    : null,
              ),
              autocorrect: true,
              textInputAction: TextInputAction.next,
              onEditingComplete: _nameEditingComplete,
              onChanged: (name) => _updateState(),
            ),
            TextFormField(
              controller: _caloriesController,
              focusNode: _caloriesFocusNode,
              decoration: InputDecoration(
                hintText: 'Calories per 100g',
                errorText: _showInputErrors && !_isValidCalories
                    ? 'Only numbers. Use "." instead of ","'
                    : null,
              ),
              autocorrect: false,
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
              textInputAction: TextInputAction.next,
              onEditingComplete: _caloriesEditingComplete,
              onChanged: (name) => _updateState(),
            ),
            TextFormField(
              controller: _proteinsController,
              focusNode: _proteinsFocusNode,
              decoration: InputDecoration(
                hintText: 'Proteins per 100g',
                errorText: _showInputErrors && !_isValidProteins
                    ? 'Only numbers. Use "." instead of ","'
                    : null,
              ),
              autocorrect: false,
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
              textInputAction: TextInputAction.next,
              onEditingComplete: _proteinsEditingComplete,
              onChanged: (name) => _updateState(),
            ),
            TextFormField(
              controller: _carbsController,
              focusNode: _carbsFocusNode,
              decoration: InputDecoration(
                hintText: 'Carbs per 100g',
                errorText: _showInputErrors && !_isValidCarbs
                    ? 'Only numbers. Use "." instead of ","'
                    : null,
              ),
              autocorrect: false,
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
              textInputAction: TextInputAction.next,
              onEditingComplete: _carbsEditingComplete,
              onChanged: (name) => _updateState(),
            ),
            TextFormField(
              controller: _fatController,
              focusNode: _fatFocusNode,
              decoration: InputDecoration(
                hintText: 'Fat per 100g',
                errorText: _showInputErrors && !_isValidFat
                    ? 'Only numbers. Use "." instead of ","'
                    : null,
              ),
              autocorrect: false,
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
              textInputAction: TextInputAction.next,
              onEditingComplete: () => _submit(auth, repo),
              onChanged: (name) => _updateState(),
            ),
            const SizedBox(
              height: 20.0,
            ),
            MainButton(
              callback: !_isLoading ? () => _submit(auth, repo) : null,
              label: 'Create Ingredient',
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
                onPressed: () async {
                  String barcode = await scan();
                  send(barcode);
                },
                child: Text("scan")),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(onPressed: () {}, child: Text("send request")),
          ],
        ),
      ),
    );
  }

  Future<String> scan() async {
    String barcode = "";
    return await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", false, ScanMode.DEFAULT);
  }

  Future<void> _sendBarcode() async {
    String barcode = "";
    scan().then((value) {
      barcode = value;
    });
    print(barcode);
    print(barcode);
    print(barcode);
    print(barcode);
    print(barcode);
    print(barcode);
    print(barcode);
    print(barcode);
    print(barcode);
    var response = await http
        .get(
      Uri.parse('https://world.openfoodfacts.org/api/v0/product/$barcode.json'),
    )
        .then((response) {
      Ingredient ingredient = Ingredient.fromJson(jsonDecode(response.body));

      print(ingredient);
      print(ingredient);
      print(ingredient);
      print(ingredient);
      print(ingredient);
      print(ingredient);
      print(ingredient);
      print(ingredient);
      print(ingredient);
      print(ingredient);
      print(ingredient);
      print(ingredient);
      print(ingredient);
      print(ingredient);

      _nameController.text = ingredient.name;
      _caloriesController.text = ingredient.caloriesPer100g.toString();
      _proteinsController.text = ingredient.proteinsPer100g.toString();
      _fatController.text = ingredient.fatPer100g.toString();
      _carbsController.text = ingredient.carbsPer100g.toString();
      _updateState();
    }).catchError((error) {
      print('error: $error');
    });

    // if (response.statusCode == 200) {
    //   // If the server did return a 201 CREATED response,
    //   // then parse the JSON.

    //   print(ingredient);
    //   print(ingredient);
    //   print(ingredient);
    //   print(ingredient);
    //   print(ingredient);
    //   print(ingredient);
    //   print(ingredient);
    //   print(ingredient);
    // } else {
    //   // If the server did not return a 201 CREATED response,
    //   // then throw an exception.

    //   throw Exception('Failed to create album.');
    // }
  }

  Future<void> send(String barcode) async {
    print('BARCODE: $barcode');
    print('BARCODE: $barcode');
    print('BARCODE: $barcode');
    print('BARCODE: $barcode');
    print('BARCODE: $barcode');
    print('BARCODE: $barcode');
    print('BARCODE: $barcode');
    print('BARCODE: $barcode');
    print('BARCODE: $barcode');
    print('BARCODE: $barcode');
    print('BARCODE: $barcode');

    var response = await http.get(
      Uri.parse('https://world.openfoodfacts.org/api/v0/product/$barcode.json'),
    );

    print('RESPONSE: $response');
    print('RESPONSE: $response');
    print('RESPONSE: $response');
    print('RESPONSE: $response');
    print('RESPONSE: $response');
    print('RESPONSE: $response');
    print('RESPONSE: $response');
    print('RESPONSE: $response');
    print('RESPONSE: $response');
    print('RESPONSE: $response');

    Ingredient ingredient = Ingredient.fromJson(jsonDecode(response.body));

    print(ingredient);
    print(ingredient);
    print(ingredient);
    print(ingredient);
    print(ingredient);
    print(ingredient);
    print(ingredient);
    print(ingredient);
    print(ingredient);
    print(ingredient);
    print(ingredient);

    _nameController.text = ingredient.name;
    _caloriesController.text = ingredient.caloriesPer100g.toString();
    _proteinsController.text = ingredient.proteinsPer100g.toString();
    _fatController.text = ingredient.fatPer100g.toString();
    _carbsController.text = ingredient.carbsPer100g.toString();
  }
}
