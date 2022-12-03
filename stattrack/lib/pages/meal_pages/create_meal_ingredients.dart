import 'dart:async';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:stattrack/components/buttons/main_button.dart';
import 'package:stattrack/components/forms/form_fields/bordered_text_input.dart';
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
  const CreateMealIngredients({Key? key}) : super(key: key);

  @override
  _CreateMealIngredientsState createState() => _CreateMealIngredientsState();
}

class _CreateMealIngredientsState extends ConsumerState<CreateMealIngredients> {
  final TextEditingController _controller = TextEditingController();

  String get _amount => _controller.text;

  bool get _isValidAmount => Validator.isPositiveFloat(_amount);

  late StreamSubscription<List<Ingredient>?> _ingredientStreamSubscription;
  List<Ingredient>? _ingredients;
  String? _selectedIngredient;

  Map<String, num> _ingredientMap = {};

  @override
  void initState() {
    super.initState();

    final AuthBase auth = ref.read(authProvider);
    final Repository repo = ref.read(repositoryProvider);

    _ingredientStreamSubscription =
        repo.getIngredients(auth.currentUser!.uid).listen((ingredients) {
      setState(() {
        _ingredients = ingredients;
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

  void _addIngredient() {
    if (_selectedIngredient == null || !_isValidAmount) return;
    // TODO: Fix add implementation
    _ingredientMap[_selectedIngredient!] = num.parse(_amount);
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
            )
          ],
        ),
        _buildIngredientSelect(),
        const SizedBox(
          height: 20.0,
        ),
        _buildIngredientList(),
      ],
    );
  }

  Widget _buildIngredientSelect() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: DropdownSearch<String>(
                selectedItem: _selectedIngredient,
                dropdownDecoratorProps: const DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    labelText: 'Ingredient',
                    hintText: 'Ingredient',
                  ),
                ),
                items: _ingredients != null
                    ? _ingredients!
                        .map((ingredient) => ingredient.name)
                        .toList()
                    : [],
                onChanged: (value) => setState(() {
                  _selectedIngredient = value;
                }),
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
      ],
    );
  }

  Widget _buildIngredientList() {
    const SizedBox separetor = SizedBox(
      height: 6.0,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Ingredient',
              style: TextStyle(fontWeight: FontStyles.fwTitle),
            ),
            separetor,
            ..._creatIngredientNameList(separetor)
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            const Text(
              'Amount',
              style: TextStyle(fontWeight: FontStyles.fwTitle),
            ),
            separetor,
            ..._creatIngredientValueList(separetor)
          ],
        ),
      ],
    );
  }

  List<Widget> _creatIngredientNameList(SizedBox separetor) {
    List<Widget> list = [];

    for (String? string in _ingredientMap.keys) {
      list.add(
        Text('$string'),
      );
      list.add(separetor);
    }

    return list;
  }

  List<Widget> _creatIngredientValueList(SizedBox separetor) {
    List<Widget> list = [];

    for (num value in _ingredientMap.values) {
      list.add(
        Text('${value}g'),
      );
      list.add(separetor);
    }

    return list;
  }
}
