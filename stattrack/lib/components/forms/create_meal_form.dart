import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:stattrack/components/buttons/main_button.dart';
import 'package:stattrack/components/forms/form_fields/bordered_text_input.dart';
import 'package:stattrack/components/forms/form_fields/image_picker_input.dart';
import 'package:stattrack/components/forms/form_fields/ingredient_select.dart';
import 'package:stattrack/components/forms/form_fields/instructions_field.dart';
import 'package:stattrack/models/IngredientAmount.dart';
import 'package:stattrack/models/ingredient.dart';
import 'package:stattrack/models/meal.dart';
import 'package:stattrack/pages/meal_pages/create_ingredient_page.dart';
import 'package:stattrack/providers/auth_provider.dart';
import 'package:stattrack/providers/meal_service_provider.dart';
import 'package:stattrack/providers/repository_provider.dart';
import 'package:stattrack/repository/repository.dart';
import 'package:stattrack/services/api_paths.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/services/meal_service.dart';
import 'package:stattrack/styles/font_styles.dart';
import 'package:stattrack/styles/palette.dart';

class CreateMealForm extends ConsumerStatefulWidget {
  const CreateMealForm({Key? key, required this.storedIngredients})
      : super(key: key);

  final List<Ingredient> storedIngredients;

  @override
  _CreateMealFormState createState() => _CreateMealFormState();
}

class _CreateMealFormState extends ConsumerState<CreateMealForm> {
  final TextEditingController _nameController = TextEditingController();

  String get _name => _nameController.text;
  bool get _isValidName => _name.isNotEmpty;

  XFile? _image;
  num _ingredientIndex = 0;
  Map<num, IngredientAmount?> _ingredients = {};
  num _instructionIndex = 0;
  Map<num, String?> _instructions = {};

  @override
  void initState() {
    super.initState();
    _ingredients = {_ingredientIndex: null};
    _instructions = {_instructionIndex: null};
  }

  void _updateState() {
    setState(() {});
  }

  void _addIngredient() {
    setState(() {
      _ingredientIndex = _ingredientIndex + 1;
    });
    _ingredients[_ingredientIndex] = null;
  }

  void _addInstruction() {
    setState(() {
      _instructionIndex = _instructionIndex + 1;
    });
    _instructions[_instructionIndex] = null;
  }

  void _navToCreateIngredient(BuildContext context) {
    Navigator.push(
      context,
      PageTransition(
        child: const CreateIngredientPage(),
        type: PageTransitionType.rightToLeft,
      ),
    );
  }

  /// Adds a meal to the logged in user
  void _addMeal(
      BuildContext context, AuthBase auth, MealService mealService) async {
    if (!_isValidName) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Meal needs a name!'),
        ),
      );
    } else if (_ingredients.values.contains(null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Make sure all ingredients are filled out!'),
        ),
      );
    } else if (_instructions.values.contains(null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Make sure all instructions are filled out!'),
        ),
      );
    } else if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Need to select an image'),
        ),
      );
    } else {
      Map<String, num> ingredients = {};
      num calories = 0;
      num proteins = 0;
      num fat = 0;
      num carbs = 0;
      for (var ingredientAmount in _ingredients.values) {
        ingredients[ingredientAmount!.ingredient.name] =
            ingredientAmount.amount;
        calories += ingredientAmount.ingredient.caloriesPerUnit *
            ingredientAmount.amount /
            100;
        proteins += ingredientAmount.ingredient.proteinsPerUnit *
            ingredientAmount.amount /
            100;
        fat += ingredientAmount.ingredient.fatPerUnit *
            ingredientAmount.amount /
            100;
        carbs += ingredientAmount.ingredient.carbsPerUnit *
            ingredientAmount.amount /
            100;
      }

      mealService.addMeal(
        meal: Meal(
          id: UniqueKey().toString(),
          name: _name,
          imageUrl: null,
          ingredients: ingredients,
          instuctions: _instructions.values.toList(),
          calories: calories,
          proteins: proteins,
          fat: fat,
          carbs: carbs,
        ),
        uid: auth.currentUser!.uid,
        imageFile: File(_image!.path),
      );

      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  /// Updates an ingredient
  ///
  /// [index] the index of the ingredient to update
  /// [ingredient] the ingredient to update it to
  /// [amount] the amount of the updated ingredient
  void _updateIngredient(num index, Ingredient ingredient, num amount) {
    setState(() {
      _ingredients[index] =
          IngredientAmount(ingredient: ingredient, amount: amount);
    });
  }

  /// Deletes an ingredient
  ///
  /// [index] the index of the ingredient to delete
  void _deleteIngredient(num index) {
    setState(() {
      _ingredients.remove(index);
    });
  }

  /// Updates the value of an instructions
  ///
  /// [index] index of the instruction to update
  /// [value] the value to update the instruction to
  void _updateInstruction(num index, String value) {
    setState(() {
      _instructions[index] = value;
    });
  }

  /// Deletes an instruction
  ///
  /// [index] the instruction to delete
  void _deleteInstruction(num index) {
    setState(() {
      _instructions.remove(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthBase auth = ref.read(authProvider);
    final MealService mealService = ref.read(mealServiceProvider);

    const elementSpacing = 10.0;
    const sectionSpacing = 25.0;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildHeading('Info'),
          const SizedBox(
            height: elementSpacing,
          ),
          BorderedTextInput(
            controller: _nameController,
            hintText: 'Name',
            textInputAction: TextInputAction.done,
            onEditingComplete: () => FocusScope.of(context).unfocus(),
            onChanged: (name) => _updateState,
          ),
          const SizedBox(
            height: elementSpacing,
          ),
          ImagePickerInput(
            onImagePicked: (image) => setState(() => _image = image),
            label: _image == null ? 'Select image' : _image!.name,
          ),
          const SizedBox(
            height: sectionSpacing,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildHeading('Ingredients'),
              TextButton(
                onPressed: () => _navToCreateIngredient(context),
                child: Text(
                  'Create ingredient',
                  style: TextStyle(
                    color: Palette.accent[200],
                    fontSize: FontStyles.fsBody,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: elementSpacing,
          ),
          ..._ingredients.keys.map((index) {
            return IngredientSelect(
              index: index,
              ingredients: widget.storedIngredients,
              onChange: (i, selectedIngredient, amount) =>
                  _updateIngredient(i, selectedIngredient, amount),
              delete: (i) => _deleteIngredient(i),
            );
          }),
          MainButton(
            callback: _addIngredient,
            label: 'Add ingredient',
            padding: const EdgeInsets.all(16.0),
            backgroundColor: Colors.white,
            color: Palette.accent[400],
          ),
          const SizedBox(
            height: sectionSpacing,
          ),
          _buildHeading('Instructions'),
          const SizedBox(
            height: elementSpacing,
          ),
          ..._instructions.keys.map((index) {
            return InstructionsField(
              index: index,
              onChange: (i, value) => _updateInstruction(i, value),
              delete: (i) => _deleteInstruction(i),
            );
          }),
          MainButton(
            callback: _addInstruction,
            label: 'Add instruction',
            padding: const EdgeInsets.all(16.0),
            backgroundColor: Colors.white,
            color: Palette.accent[400],
          ),
          const SizedBox(
            height: 50.0,
          ),
          MainButton(
            callback: () => _addMeal(context, auth, mealService),
            label: 'Create meal',
            padding: const EdgeInsets.all(16.0),
          ),
        ],
      ),
    );
  }

  /// Creates a heading with correct styles
  ///
  /// [title] the string that should be displayed in the heading
  Text _buildHeading(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: FontStyles.fsBody,
        fontWeight: FontStyles.fw600,
      ),
    );
  }
}
