import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';
import 'package:stattrack/components/buttons/main_button.dart';
import 'package:stattrack/styles/font_styles.dart';

class AccountSetupNoobEstimate extends StatelessWidget {
  const AccountSetupNoobEstimate({
    Key? key,
    required this.weight,
    required this.activityLevel,
    required this.weightDirection,
    required this.onComplete,
  }) : super(key: key);

  final num weight;
  final num activityLevel;
  final String weightDirection;
  final void Function(num, num, num, num) onComplete;

  /// Returns an estimated daily calorie consumption based on weight,
  /// activity level and which direction you want to go (up, down or stay
  /// at current weight)
  num _getCalories() {
    // Formula:
    // - Bodyweight * 22 = estimate caloreis for just laying around all day
    // - Take the estimate times a number between 1 and2 where 1 represent
    // almost no activity, and 2 represent a lot of activity throughout the day
    // - Then multiply this by a procentage in increase or decrease depending
    // on if you want to go down or up in weight.

    // Bodyweight * 22 = estimte for doing nothing
    num calories = weight * 22;

    // Times a number between 1 and 2 representing the persons activity
    // throughout the day
    if (activityLevel == 1) {
      calories = calories * 1.3;
    } else if (activityLevel == 2) {
      calories = calories * 1.5;
    } else if (activityLevel == 3) {
      calories = calories * 1.8;
    }

    // Times 1.1 for 10% increase or 0.9 for 10% decrease
    if (weightDirection == 'gain') {
      calories = calories * 1.1;
    } else if (weightDirection == 'lose') {
      calories = calories * 0.9;
    }

    return calories;
  }

  /// Returns estimated number of proteins to consume per day. Based on
  /// weight
  num _getProteins() {
    // Grams of proteins per day is bodyweight * 2
    return weight * 2;
  }

  /// Returns estimated number of fat to consume per day. Based on calorie
  /// consumption.
  num _getFat() {
    // Grams of fat per day is your bodyweight
    return weight;
  }

  /// Returns estimeated number of carbs to consume per day.
  num _getCarbs() {
    // Grams of carbs per day is whatever you have left of your daily
    // calorie consumption after you take account for protein and fat
    num caloriesPerGramProtein = 4;
    num caloriesPerGramFat = 9;
    num caloriesPerGramCarbs = 4;

    return (_getCalories() -
            (_getProteins() * caloriesPerGramProtein) -
            (_getFat() * caloriesPerGramFat)) /
        caloriesPerGramCarbs;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'This is what we have calculated for you:',
              style: TextStyle(
                fontWeight: FontStyles.fwTitle,
              ),
            ),
            const SizedBox(
              height: 25.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Calories:',
                  style: TextStyle(
                    fontWeight: FontStyles.fwTitle,
                  ),
                ),
                Text('${_getCalories().round()}kcal'),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Proteins:',
                  style: TextStyle(
                    fontWeight: FontStyles.fwTitle,
                  ),
                ),
                Text('${_getProteins().round()}g'),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Carbs:',
                  style: TextStyle(
                    fontWeight: FontStyles.fwTitle,
                  ),
                ),
                Text('${_getCarbs().round()}g'),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Fat:',
                  style: TextStyle(
                    fontWeight: FontStyles.fwTitle,
                  ),
                ),
                Text('${_getFat().round()}g'),
              ],
            ),
            const SizedBox(
              height: 25.0,
            ),
            const Text(
              'Try these macros for a week and step one a weight every day at the same time and see if your bodyweight is changing in the right directions. Remember, these numbers are only estimate and might vary from person to person. Thats why you can, whenever you feel like it, go to settings and change them manually if your weight is not going in the right direction:)',
            ),
          ],
        ),
        MainButton(
          callback: () => onComplete(_getCalories().round(),
              _getProteins().round(), _getCarbs().round(), _getFat().round()),
          label: 'Complete setup',
        )
      ],
    );
  }
}
