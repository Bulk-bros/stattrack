import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:stattrack/components/forms/form_fields/bordered_text_input.dart';
import 'package:stattrack/components/forms/form_fields/image_picker_input.dart';
import 'package:stattrack/components/forms/form_fields/ingredient_select.dart';
import 'package:stattrack/models/ingredient.dart';
import 'package:stattrack/pages/create_ingredient_page.dart';
import 'package:stattrack/styles/font_styles.dart';
import 'package:stattrack/styles/palette.dart';

class _MealIngredient {
  const _MealIngredient(
      {Key? key, required this.ingredient, required this.amount});

  final Ingredient ingredient;
  final num amount;
}

class CreateMealForm extends StatefulWidget {
  const CreateMealForm({Key? key, required this.storedIngredients})
      : super(key: key);

  final List<Ingredient> storedIngredients;

  @override
  _CreateMealFormState createState() => _CreateMealFormState();
}

class _CreateMealFormState extends State<CreateMealForm> {
  final TextEditingController _nameController = TextEditingController();

  String get _name => _nameController.text;
  XFile? _image;
  num _ingredientIndex = 0;
  Map<num, _MealIngredient?> _ingredients = {};
  num _instructionIndex = 0;
  Map<num, String?> _instructions = {};

  @override
  void initState() {
    _ingredients = {_ingredientIndex: null};
    _instructions = {_instructionIndex: null};
  }

  void _submit() {
    print(_name);
  }

  void _updateState() {
    setState(() {});
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

  @override
  Widget build(BuildContext context) {
    const elementSpacing = 10.0;
    const sectionSpacing = 25.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        _buildHeading('Info'),
        const SizedBox(
          height: elementSpacing,
        ),
        BorderedTextInput(
          controller: _nameController,
          hintText: 'Name',
          textInputAction: TextInputAction.next,
          onEditingComplete: _submit,
          onChanged: (name) => _updateState,
        ),
        const SizedBox(
          height: elementSpacing,
        ),
        ImagePickerInput(
          onImagePicked: (image) => setState(() => _image = image),
          label: 'Image',
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
        ..._ingredients.keys.map((index) {
          return IngredientSelect(
              index: index,
              ingredients: widget.storedIngredients,
              onChange: (i) => {});
        }),
      ],
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
