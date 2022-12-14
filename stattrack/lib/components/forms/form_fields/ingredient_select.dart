import 'package:flutter/material.dart';
import 'package:stattrack/components/forms/form_fields/bordered_text_input.dart';
import 'package:stattrack/models/ingredient.dart';
import 'package:stattrack/utils/validator.dart';

class IngredientSelect extends StatefulWidget {
  const IngredientSelect({
    Key? key,
    required this.index,
    required this.ingredients,
    required this.onChange,
    required this.delete,
  }) : super(key: key);

  final num index;
  final List<Ingredient> ingredients;
  final void Function(num, Ingredient, num) onChange;
  final void Function(num) delete;

  @override
  _IngredientSelectState createState() => _IngredientSelectState();
}

class _IngredientSelectState extends State<IngredientSelect> {
  final TextEditingController _controller = TextEditingController();
  String get _amount => _controller.text;
  bool get _isValidAmount => Validator.isPositiveFloat(_amount);

  Ingredient? _selectedIngredient;

  var seen = <Ingredient>{};

  List<DropdownMenuItem<Ingredient>> _buildDropdownMenuItems() {
    return widget.ingredients
        .where((element) => !seen.contains(element))
        .map((ingredient) => DropdownMenuItem<Ingredient>(
              value: ingredient,
              child: Text(ingredient.name),
            ))
        .toList();
  }

  void _updateState() {
    setState(() {});
    _update();
  }

  void _updateSelectedIngredient(Ingredient? ingredient) {
    setState(() {
      _selectedIngredient = ingredient;
    });
    _update();
  }

  void _update() {
    if (_selectedIngredient == null || !_isValidAmount) return;
    widget.onChange(widget.index, _selectedIngredient!, num.parse(_amount));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: DropdownButton<Ingredient>(
                hint: const Text('Select ingredient'),
                value: List.from(seen).contains(_selectedIngredient)
                    ? null
                    : _selectedIngredient,
                icon: const Icon(Icons.arrow_drop_down),
                elevation: 16,
                style: const TextStyle(
                  color: Colors.black87,
                ),
                underline: Container(
                  height: 1.0,
                  color: Colors.black87,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                isExpanded: true,
                onChanged: (Ingredient? value) =>
                    _updateSelectedIngredient(value),
                items: _buildDropdownMenuItems(),
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Flexible(
              child: BorderedTextInput(
                controller: _controller,
                hintText: 'Amount (g)',
                textInputAction: TextInputAction.done,
                keyboardType: const TextInputType.numberWithOptions(
                    decimal: true, signed: true),
                onEditingComplete: () => FocusScope.of(context).unfocus(),
                onChanged: (amount) => _updateState(),
              ),
            ),
            IconButton(
              onPressed: () => widget.delete(widget.index),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        ),
      ],
    );
  }
}
