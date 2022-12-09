import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stattrack/components/app/custom_app_bar.dart';
import 'package:stattrack/components/buttons/main_button.dart';
import 'package:stattrack/components/forms/form_fields/bordered_text_input.dart';
import 'package:stattrack/models/ingredient.dart';
import 'package:stattrack/providers/auth_provider.dart';
import 'package:stattrack/providers/ingredient_service_provider.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/services/ingredient_service.dart';
import 'package:stattrack/utils/validator.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

class CreateIngredientPage extends ConsumerStatefulWidget {
  const CreateIngredientPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateIngredientPage> createState() =>
      _CreateIngredientPageState();
}

class _CreateIngredientPageState extends ConsumerState<CreateIngredientPage> {
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _caloriesFocusNode = FocusNode();
  final FocusNode _proteinsFocusNode = FocusNode();
  final FocusNode _carbsFocusNode = FocusNode();
  final FocusNode _fatFocusNode = FocusNode();
  final FocusNode _saltFocusNode = FocusNode();
  final FocusNode _saturatedFatFocusNode = FocusNode();
  final FocusNode _sugarFocusNode = FocusNode();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _proteinsController = TextEditingController();
  final TextEditingController _carbsController = TextEditingController();
  final TextEditingController _fatController = TextEditingController();
  final TextEditingController _saltController = TextEditingController();
  final TextEditingController _saturatedFatController = TextEditingController();
  final TextEditingController _sugarController = TextEditingController();

  String get _name => _nameController.text;
  String get _calories => _caloriesController.text;
  String get _proteins => _proteinsController.text;
  String get _carbs => _carbsController.text;
  String get _fat => _fatController.text;
  String get _salt => _saltController.text;
  String get _saturatedFat => _saturatedFatController.text;
  String get _sugar => _sugarController.text;

  bool get _isValidName => _name.isNotEmpty;
  bool get _isValidCalories => Validator.isPositiveFloat(_calories);
  bool get _isValidProteins => Validator.isPositiveFloat(_proteins);
  bool get _isValidCarbs => Validator.isPositiveFloat(_carbs);
  bool get _isValidFat => Validator.isPositiveFloat(_fat);
  bool get _isValidSalt => Validator.isPositiveFloat(_salt);
  bool get _isValidSaturatedFat => Validator.isPositiveFloat(_saturatedFat);
  bool get _isValidSugar => Validator.isPositiveFloat(_sugar);

  bool _isLoading = false;

  bool _showError = false;
  String _errorMsg = '';

  void _submit(AuthBase auth) async {
    setState(() {
      _isLoading = true;
    });
    try {
      if (!_isValidName ||
          !_isValidCalories ||
          !_isValidProteins ||
          !_isValidCarbs ||
          !_isValidFat ||
          !_isValidSalt ||
          !_isValidSaturatedFat ||
          !_isValidSugar) {
        throw Exception('Invalid inputs');
      }

      final IngredientService ingredientService =
          ref.read(ingredientServiceProvider);

      await ingredientService.addIngredient(
          Ingredient(
            name: _name,
            unit: '100g',
            caloriesPerUnit: num.parse(_calories),
            proteinsPerUnit: num.parse(_proteins),
            fatPerUnit: num.parse(_fat),
            carbsPerUnit: num.parse(_carbs),
            saturatedFatPerUnit: num.parse(_saturatedFat),
            saltPerUnit: num.parse(_salt),
            sugarsPerUnit: num.parse(_sugar),
          ),
          auth.currentUser!.uid);
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _errorMsg = 'Something went wrong, please try again!';
        _showError = true;
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
    final newFocus = _isValidCalories ? _fatFocusNode : _caloriesFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _fatEditingComplete() {
    final newFocus = _isValidFat ? _saturatedFatFocusNode : _fatFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _saturatedFatEditingComplete() {
    final newFocus =
        _isValidSaturatedFat ? _carbsFocusNode : _saturatedFatFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _carbsEditingComplete() {
    final newFocus = _isValidCarbs ? _sugarFocusNode : _carbsFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _sugarEditingComplete() {
    final newFocus = _isValidSugar ? _proteinsFocusNode : _sugarFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _proteinEditingComplete() {
    final newFocus = _isValidProteins ? _saltFocusNode : _proteinsFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _handleBarcodeButton() async {
    await send(await scan());
  }

  Future<String> scan() async {
    setState(() {
      _showError = false;
    });

    return await FlutterBarcodeScanner.scanBarcode(
        "#ff51cf66", "Cancel", true, ScanMode.BARCODE);
  }

  Future<void> send(String barcode) async {
    String url = 'https://world.openfoodfacts.org/api/v0/product/$barcode.json';
    var response = await http.get(
      Uri.parse(url),
    );

    try {
      Ingredient ingredient = Ingredient.fromJson(jsonDecode(response.body));

      _nameController.text = ingredient.name;
      _caloriesController.text = ingredient.caloriesPerUnit.toString();
      _proteinsController.text = ingredient.proteinsPerUnit.toString();
      _fatController.text = ingredient.fatPerUnit.toString();
      _saturatedFatController.text = ingredient.saturatedFatPerUnit.toString();
      _carbsController.text = ingredient.carbsPerUnit.toString();
      _sugarController.text = ingredient.sugarsPerUnit.toString();
      _saltController.text = ingredient.saltPerUnit.toString();
    } catch (e) {
      setState(() {
        _errorMsg = 'Product not found, please enter nutriments manually :(';
        _showError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        headerTitle: 'Create Ingredient',
        actions: [
          Transform.rotate(
            angle: -90 * math.pi / 180,
            child: IconButton(
              onPressed: _handleBarcodeButton,
              icon: const Icon(Icons.document_scanner_outlined),
            ),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    final AuthBase auth = ref.read(authProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(31.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _showError
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          _errorMsg,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red[700],
                            fontSize: 12.0,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    )
                  : const SizedBox(
                      height: 0,
                    ),
              BorderedTextInput(
                titleText: "Ingredient name",
                hintText: "Ingredient name",
                controller: _nameController,
                focusNode: _nameFocusNode,
                textInputAction: TextInputAction.next,
                onEditingComplete: _nameEditingComplete,
                onChanged: (name) => _updateState(),
              ),
              BorderedTextInput(
                titleText: "Calories",
                hintText: "Calories per 100g",
                controller: _caloriesController,
                focusNode: _caloriesFocusNode,
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
                textInputAction: TextInputAction.next,
                onEditingComplete: _caloriesEditingComplete,
                onChanged: (name) => _updateState(),
              ),
              BorderedTextInput(
                titleText: "Fat",
                hintText: "Fat per 100g",
                controller: _fatController,
                focusNode: _fatFocusNode,
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
                textInputAction: TextInputAction.next,
                onEditingComplete: _fatEditingComplete,
                onChanged: (name) => _updateState(),
              ),
              BorderedTextInput(
                titleText: "Saturated fat",
                hintText: "Saturated fat per 100g",
                controller: _saturatedFatController,
                focusNode: _saturatedFatFocusNode,
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
                textInputAction: TextInputAction.next,
                onEditingComplete: _saturatedFatEditingComplete,
                onChanged: (name) => _updateState(),
              ),
              BorderedTextInput(
                titleText: "Carbs",
                hintText: "Carbs per 100g",
                controller: _carbsController,
                focusNode: _carbsFocusNode,
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
                textInputAction: TextInputAction.next,
                onEditingComplete: _carbsEditingComplete,
                onChanged: (name) => _updateState(),
              ),
              BorderedTextInput(
                titleText: "Sugars",
                hintText: "Sugars per 100g",
                controller: _sugarController,
                focusNode: _sugarFocusNode,
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
                textInputAction: TextInputAction.next,
                onEditingComplete: _sugarEditingComplete,
                onChanged: (name) => _updateState(),
              ),
              BorderedTextInput(
                titleText: "Proteins",
                hintText: "Proteins per 100g",
                controller: _proteinsController,
                focusNode: _proteinsFocusNode,
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
                textInputAction: TextInputAction.next,
                onEditingComplete: () => _proteinEditingComplete(),
                onChanged: (name) => _updateState(),
              ),
              BorderedTextInput(
                titleText: "Salt",
                hintText: "Salts per 100g",
                controller: _saltController,
                focusNode: _saltFocusNode,
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
                textInputAction: TextInputAction.done,
                onEditingComplete: () => _submit(auth),
                onChanged: (name) => _updateState(),
              ),
              const SizedBox(
                height: 20.0,
              ),
              MainButton(
                callback: !_isLoading ? () => _submit(auth) : null,
                label: 'Create Ingredient',
              ),
              const SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
