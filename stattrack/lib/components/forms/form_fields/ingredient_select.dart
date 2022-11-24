import 'package:flutter/material.dart';
import 'package:stattrack/models/ingredient.dart';

class IngredientSelect extends StatefulWidget {
  const IngredientSelect(
      {Key? key,
      required this.index,
      required this.ingredients,
      required this.onChange})
      : super(key: key);

  final num index;
  final List<Ingredient> ingredients;
  final void Function(num) onChange;

  @override
  _IngredientSelectState createState() => _IngredientSelectState();
}

class _IngredientSelectState extends State<IngredientSelect> {
  Ingredient? _selectedIngredient;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        DropdownButton<Ingredient>(
          value: _selectedIngredient,
          icon: const Icon(Icons.arrow_downward),
          elevation: 16,
          style: const TextStyle(color: Colors.black87),
          underline: Container(height: 2.0, color: Colors.black87),
          onChanged: (Ingredient? value) {
            setState(() {
              _selectedIngredient = value;
            });
          },
          items: widget.ingredients
              .map<DropdownMenuItem<Ingredient>>((Ingredient value) {
            return DropdownMenuItem<Ingredient>(
              value: value,
              child: Text(value.name),
            );
          }).toList(),
        ),
      ],
    );
  }
}
