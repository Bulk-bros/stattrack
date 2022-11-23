import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stattrack/models/ingredient.dart';

class SingleIngredientForm extends StatefulWidget {
  const SingleIngredientForm({Key? key, required this.ingredients})
      : super(key: key);

  final List<Ingredient> ingredients;

  @override
  _SingleIngredientFormState createState() => _SingleIngredientFormState();
}

class _SingleIngredientFormState extends State<SingleIngredientForm> {
  final TextEditingController _controller = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  Ingredient? selected;

  void _updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        const Text('Select ingredient'),
      ],
    );
  }
}
