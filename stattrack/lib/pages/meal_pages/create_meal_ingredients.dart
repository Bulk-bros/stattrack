import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:stattrack/components/buttons/main_button.dart';
import 'package:stattrack/components/forms/form_fields/bordered_text_input.dart';
import 'package:stattrack/models/IngredientAmount.dart';
import 'package:stattrack/models/ingredient.dart';
import 'package:stattrack/pages/meal_pages/create_ingredient_page.dart';
import 'package:stattrack/providers/auth_provider.dart';
import 'package:stattrack/providers/repository_provider.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/services/repository.dart';
import 'package:stattrack/styles/font_styles.dart';
import 'package:stattrack/styles/palette.dart';
import 'package:stattrack/utils/validator.dart';

class CreateMealIngredients extends ConsumerStatefulWidget {
  const CreateMealIngredients(
      {Key? key, required this.navPrev, required this.onComplete})
      : super(key: key);

  final void Function() navPrev;
  final void Function(Map<String, num>, num, num, num, num) onComplete;

  @override
  _CreateMealIngredientsState createState() => _CreateMealIngredientsState();
}

class _CreateMealIngredientsState extends ConsumerState<CreateMealIngredients> {
  final TextEditingController _controller = TextEditingController();

  String get _amount => _controller.text;

  bool get _isValidAmount => Validator.isPositiveFloat(_amount);

  late StreamSubscription<List<Ingredient>?> _ingredientStreamSubscription;
  List<Ingredient>? _storedIngredients;
  var seen = <Ingredient>{};

  num _ingredientIndex = 0;
  Map<num, IngredientAmount> _selectedIngredients = {};
  Ingredient? _activeDropdownItem;

  String _errorMsg = '';
  bool _showError = false;

  @override
  void initState() {
    super.initState();

    final AuthBase auth = ref.read(authProvider);
    final Repository repo = ref.read(repositoryProvider);

    _ingredientStreamSubscription =
        repo.getIngredients(auth.currentUser!.uid).listen((ingredients) {
      setState(() {
        _storedIngredients = ingredients;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    _ingredientStreamSubscription.cancel();
  }

  void _updateState() {
    setState(() {});
  }

  void _handleComplete() {
    setState(() {
      _showError = false;
    });
    if (_selectedIngredients.isEmpty) {
      setState(() {
        _errorMsg = 'Need atleast one ingredient!';
        _showError = true;
      });
    } else {
      Map<String, num> ingredients = {};
      num calories = 0;
      num fat = 0;
      num carbs = 0;
      num proteins = 0;
      for (var ingredientAmount in _selectedIngredients.values) {
        ingredients[ingredientAmount.ingredient.name] = ingredientAmount.amount;
        calories += ingredientAmount.ingredient.caloriesPerUnit *
            ingredientAmount.amount /
            100;
        fat += ingredientAmount.ingredient.fatPerUnit *
            ingredientAmount.amount /
            100;
        carbs += ingredientAmount.ingredient.carbsPerUnit *
            ingredientAmount.amount /
            100;
        proteins += ingredientAmount.ingredient.proteinsPerUnit *
            ingredientAmount.amount /
            100;
      }

      widget.onComplete(ingredients, calories, fat, carbs, proteins);
    }
  }

  /// Adds an ingredient to the list from the form
  void _addIngredient() {
    setState(() {
      _showError = false;
    });
    if (_activeDropdownItem == null || !_isValidAmount) {
      setState(() {
        _errorMsg = 'Need to select an ingredient and chose amount!';
        _showError = true;
      });
    } else {
      setState(() {
        _ingredientIndex = _ingredientIndex + 1;
        _selectedIngredients[_ingredientIndex] = IngredientAmount(
            ingredient: _activeDropdownItem!, amount: num.parse(_amount));
      });
    }
  }

  /// Removes an ingredient from the list
  ///
  /// [index] the index of the ingredient to remove
  void _removeIngredient(num index) {
    setState(() {
      _selectedIngredients.remove(index);
    });
  }

  void _navToCreateIngredient(BuildContext context) {
    Navigator.of(context).push(
      PageTransition(
        child: const CreateIngredientPage(),
        type: PageTransitionType.rightToLeft,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 20.0,
        ),
        _buildHeader(),
        const SizedBox(
          height: 20.0,
        ),
        _buildIngredientSelect(),
        const SizedBox(
          height: 20.0,
        ),
        _buildIngredientList(),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: widget.navPrev,
          icon: const Icon(Icons.navigate_before),
        ),
        const Text(
          'Ingredients',
          style: TextStyle(
            fontSize: FontStyles.fsTitle1,
            fontWeight: FontStyles.fwTitle,
          ),
        ),
        TextButton(
          onPressed: _handleComplete,
          child: Text(
            'Next',
            style: TextStyle(
              color: Palette.accent[400],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildIngredientSelect() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () => _navToCreateIngredient(context),
              child: Text(
                'Create ingredient',
                style: TextStyle(
                  color: Palette.accent[400],
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: DropdownButton<Ingredient>(
                hint: const Text('Select Ingredient'),
                value: List.from(seen).contains(_activeDropdownItem)
                    ? null
                    : _activeDropdownItem,
                icon: const Icon(Icons.arrow_drop_down),
                elevation: 16,
                style: const TextStyle(
                  color: Colors.black87,
                ),
                underline: Container(
                  height: 1,
                  color: Colors.black87,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                isExpanded: true,
                onChanged: (Ingredient? value) => setState(() {
                  _activeDropdownItem = value;
                }),
                items: _buildDropdownMenuItems(),
              ),
            ),
            const SizedBox(
              width: 8.0,
            ),
            SizedBox(
              width: 120.0,
              child: BorderedTextInput(
                hintText: 'Amount (g)',
                controller: _controller,
                onChanged: (value) => _updateState,
                keyboardType: const TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
              ),
            ),
          ],
        ),
        MainButton(
          callback: _addIngredient,
          label: 'Add ingredient',
        ),
        _showError
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    _errorMsg,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red[700],
                    ),
                  ),
                ],
              )
            : const SizedBox(
                height: 0.0,
              ),
      ],
    );
  }

  List<DropdownMenuItem<Ingredient>> _buildDropdownMenuItems() {
    if (_storedIngredients == null) return [];
    return _storedIngredients!
        .where((element) => !seen.contains(element))
        .map((ingredient) => DropdownMenuItem<Ingredient>(
              value: ingredient,
              child: Text(ingredient.name),
            ))
        .toList();
  }

  Widget _buildIngredientList() {
    List<String> ingredientNames = _selectedIngredients.values
        .map((ingredientAmount) => ingredientAmount.ingredient)
        .map((ingredient) => ingredient.name)
        .toList();
    List<num> ingredientAmounts = _selectedIngredients.values
        .map((ingredientAmount) => ingredientAmount.amount)
        .toList();
    List<num> indexes = _selectedIngredients.keys.toList();

    const SizedBox separetor = SizedBox(
      height: 6.0,
    );
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ingredient',
                  style: TextStyle(
                    fontWeight: FontStyles.fwTitle,
                  ),
                ),
                Row(
                  children: const [
                    Text(
                      'Amount',
                      style: TextStyle(
                        fontWeight: FontStyles.fwTitle,
                      ),
                    ),
                    IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.close,
                        color: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            for (var i = 0; i < ingredientNames.length; i++)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(ingredientNames[i]),
                  Row(
                    children: [
                      Text('${ingredientAmounts[i]}g'),
                      IconButton(
                        onPressed: () => _removeIngredient(indexes[i]),
                        icon: const Icon(
                          Icons.close,
                          size: 16.0,
                        ),
                      )
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
