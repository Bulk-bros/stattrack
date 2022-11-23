import 'package:flutter/material.dart';
import 'package:stattrack/components/buttons/main_button.dart';
import 'package:stattrack/components/forms/form_fields/single_ingredient_form.dart';
import 'package:stattrack/models/ingredient.dart';

class IngredientList extends StatefulWidget {
  const IngredientList({Key? key, required this.ingredients}) : super(key: key);

  final List<Ingredient> ingredients;

  @override
  _IngredientListState createState() => _IngredientListState();
}

class _IngredientListState extends State<IngredientList> {
  num numberOfFields = 1;
  Map<Ingredient, num> ingredients = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildIngredientInputs(),
        MainButton(
          callback: () => setState(() {
            numberOfFields = numberOfFields + 1;
          }),
          label: 'Add ingredient',
          padding: const EdgeInsets.all(16.0),
        ),
      ],
    );
  }

  Widget _buildIngredientInputs() {
    List<Widget> list = <Widget>[];
    for (var i = 0; i < numberOfFields; i++) {
      list.add(SingleIngredientForm(ingredients: widget.ingredients));
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, children: list);
  }
}
