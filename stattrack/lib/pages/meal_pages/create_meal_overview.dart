import 'package:flutter/material.dart';
import 'package:stattrack/components/buttons/main_button.dart';
import 'package:stattrack/styles/font_styles.dart';
import 'package:stattrack/styles/palette.dart';

class CreateMealOverview extends StatelessWidget {
  const CreateMealOverview({
    Key? key,
    required this.navPrev,
    required this.onComplete,
    required this.name,
    required this.ingredients,
    required this.instructions,
    required this.calories,
    required this.fat,
    required this.carbs,
    required this.proteins,
  }) : super(key: key);

  final void Function() navPrev;
  final Future<void> Function() onComplete;
  final String name;
  final Map<String, num> ingredients;
  final List<dynamic> instructions;
  final num calories;
  final num fat;
  final num carbs;
  final num proteins;

  void _handleComplete(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: 100,
            child: Center(
              child: CircularProgressIndicator(
                color: Palette.accent[400],
              ),
            ),
          ),
        );
      },
    );
    await onComplete();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    SizedBox separator = const SizedBox(
      height: 20.0,
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(context),
              separator,
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildInfo(),
                  separator,
                  _buildNutrition(),
                  separator,
                  _buildIngredients(),
                  separator,
                  _buildInstructions(),
                  separator,
                ],
              ),
            ],
          ),
          MainButton(
            callback: () => _handleComplete(context),
            label: 'Create meal',
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: navPrev,
              icon: const Icon(Icons.navigate_before),
            ),
            const Text(
              'Instructions',
              style: TextStyle(
                fontSize: FontStyles.fsTitle1,
                fontWeight: FontStyles.fwTitle,
              ),
            ),
            TextButton(
              onPressed: () => _handleComplete(context),
              child: Text(
                'Next',
                style: TextStyle(
                  color: Palette.accent[400],
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle('Name:'),
        Text(name),
      ],
    );
  }

  Widget _buildNutrition() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle('Nutritions:'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Calories:'),
            Text('${calories.round()}kcal'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Fat:'),
            Text('${fat.round()}g'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Carbs:'),
            Text('${carbs.round()}g'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Proteins:'),
            Text('${proteins.round()}g'),
          ],
        ),
      ],
    );
  }

  Widget _buildIngredients() {
    List<String> ingredientNames = ingredients.keys.toList();
    List<num> ingredientAmounts = ingredients.values.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle('Ingredients:'),
        for (var i = 0; i < ingredientNames.length; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(ingredientNames[i]),
              ),
              Text('${ingredientAmounts[i]}g'),
            ],
          ),
      ],
    );
  }

  Widget _buildInstructions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildSectionTitle('Instructions:'),
        for (var i = 0; i < instructions.length; i++)
          Text(
            '${i + 1}. ${instructions[i]}',
          ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontStyles.fwTitle,
      ),
    );
  }
}
