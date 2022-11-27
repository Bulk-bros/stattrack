import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:stattrack/components/app/custom_body.dart';
import 'package:stattrack/components/buttons/secondary_button.dart';
import 'package:stattrack/components/app/custom_app_bar.dart';
import 'package:stattrack/components/buttons/main_button.dart';
import 'package:stattrack/components/cards/clickable_card.dart';
import 'package:stattrack/components/cards/single_stat_card.dart';
import 'package:stattrack/components/forms/form_fields/image_picker_input.dart';
import 'package:stattrack/components/meals/meal_card.dart';
import 'package:stattrack/components/stats/single_stat_layout.dart';
import 'package:stattrack/models/ingredient.dart';
import 'package:stattrack/models/meal.dart';
import 'package:stattrack/pages/settings_pages/change_password_page.dart';
import 'package:stattrack/pages/user_profile_page.dart';
import 'package:stattrack/providers/repository_provider.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/services/repository.dart';
import 'package:stattrack/styles/font_styles.dart';
import 'package:stattrack/styles/palette.dart';

import '../models/consumed_meal.dart';

class MealDetails extends StatelessWidget {
  MealDetails({Key? key, required this.meal}) : super(key: key);

  Meal meal;

  final spacing = const SizedBox(
    height: 5,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          headerTitle: "",
        ),
        body: _buildBody());
  }

  Widget _buildBody() {
    return CustomBody(
        header: _buildheader(), bodyWidgets: [..._buildBodyWidgets()]);
  }

  Widget _buildheader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 80.0,
          child: Container(
            width: 200,
            height: 200,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage("assets/images/foodstockpic.jpg"),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        _buildHeaderText(meal.name)
      ],
    );
  }

  List<Widget> _buildBodyWidgets() {
    const calorieLabel = 'Calories';
    const proteinLabel = 'Proteins';
    const fatLabel = 'Fat';
    const carbsLabel = 'Carbs';
    return [
      SingleStatCard(
        size: 160,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Nutrition",
              style: TextStyle(
                  fontSize: FontStyles.fsBody, fontWeight: FontStyles.fwTitle),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: const <Widget>[
                    Text(
                      calorieLabel,
                      style: TextStyle(
                        fontSize: FontStyles.fsTitle3,
                        fontWeight: FontStyles.fwTitle,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      proteinLabel,
                      style: TextStyle(
                        fontSize: FontStyles.fsTitle3,
                        fontWeight: FontStyles.fwTitle,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      fatLabel,
                      style: TextStyle(
                        fontSize: FontStyles.fsTitle3,
                        fontWeight: FontStyles.fwTitle,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      carbsLabel,
                      style: TextStyle(
                        fontSize: FontStyles.fsTitle3,
                        fontWeight: FontStyles.fwTitle,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      '${meal.calories} kcal',
                      style: const TextStyle(
                        fontSize: FontStyles.fsBody,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '${meal.proteins} g',
                      style: const TextStyle(
                        fontSize: FontStyles.fsBody,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '${meal.fat} g',
                      style: const TextStyle(
                        fontSize: FontStyles.fsBody,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '${meal.carbs} g',
                      style: const TextStyle(
                        fontSize: FontStyles.fsBody,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      SingleStatCard(
          content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Ingredients",
            style: TextStyle(
                fontSize: FontStyles.fsBody, fontWeight: FontStyles.fwTitle),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: [..._createIngredientList()],
                ),
              ])
        ],
      ))
    ];
  }

  List<Widget> _createIngredientList() {
    List<Widget> ingredients = [];

    if (meal.ingredients != null) {
      for (String? string in meal.ingredients!.keys) {
        ingredients.add(Text("- $string"));
      }
    } else if (meal.ingredients == null) {
      ingredients.add(const Text("No ingredients found"));
    }

    return ingredients;
  }

  Widget _buildHeaderText(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: FontStyles.fsTitle1,
          fontWeight: FontStyles.fwTitle,
          color: Colors.white),
    );
  }
}
