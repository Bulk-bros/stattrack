import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:stattrack/components/meals/add_meal_select.dart';
import 'package:stattrack/components/buttons/main_button.dart';
import 'package:stattrack/components/meals/create_meal.dart';
import 'package:stattrack/components/meals/meal_card.dart';
import 'package:stattrack/models/meal.dart';
import 'package:stattrack/providers/auth_provider.dart';
import 'package:stattrack/providers/repository_provider.dart';
import 'package:stattrack/services/auth.dart';
import 'package:stattrack/services/repository.dart';
import 'package:stattrack/styles/font_styles.dart';
import 'package:stattrack/styles/palette.dart';

// FIXME: Stream created for testing injection of stream without fetching from firestore.
// Replace the stream in the streambuilder with the one you get when creating fetch method
// and delete this class.
class MealController {
  final List<Meal> meals = [
    Meal(
      name: 'Salad',
      calories: 500,
      proteins: 20,
      fat: 5,
      carbs: 100,
    ),
    Meal(
      name: 'taco',
      calories: 500,
      proteins: 20,
      fat: 5,
      carbs: 100,
    ),
  ];

  final controller = StreamController<List<Meal>>();

  StreamController<List<Meal>> getController() {
    controller.sink.add(meals);

    return controller;
  }
}

class AddMeal extends ConsumerStatefulWidget {
  const AddMeal({Key? key}) : super(key: key);

  @override
  _AddMealState createState() => _AddMealState();
}

class _AddMealState extends ConsumerState<AddMeal> {
  final MealController mealController = MealController();

  // Stores the current active meal. The meal card that was clicked latest.
  Meal? activeMeal;

  void _showCreateMeal(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.bottomToTop,
          child: CreateMeal(),
        ));
  }

  /// Updates the active meal card
  ///
  /// [meal] the meal to set active
  void _handleMealCardPressed(Meal meal) {
    setState(() {
      activeMeal = meal;
    });
  }

  /// Adds the selected meal to log
  void _logMeal(String uid, Repository repo) {
    repo.logMeal(
      meal: activeMeal!,
      uid: uid,
    );
  }

  /// Handles the search event
  ///
  /// [searchWord] the word to seach for
  void _handleSearch(String searchWord) {
    print(searchWord);
  }

  @override
  Widget build(BuildContext context) {
    final AuthBase auth = ref.read(authProvider);
    final Repository repo = ref.read(repositoryProvider);

    return Container(
      padding: const EdgeInsetsDirectional.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Palette.accent[200],
                    fontSize: FontStyles.fsBody,
                    fontWeight: FontStyles.fwBody,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => _showCreateMeal(context),
                child: Text(
                  "Create new meal",
                  style: TextStyle(
                    color: Palette.accent[200],
                    fontSize: FontStyles.fsBody,
                    fontWeight: FontStyles.fwBody,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Search',
              hintText: 'Search for a meal',
              border: OutlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.grey,
              )),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.grey,
              )),
            ),
            textInputAction: TextInputAction.done,
            onChanged: (word) =>
                _handleSearch(word), // få den til å kalle en søkefunksjon
          ),
          const SizedBox(
            height: 20.0,
          ),
          StreamBuilder<List<Meal>>(
            stream: repo.getMeals(auth.currentUser!.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.active) {
                return const Text(
                  'No connection',
                  textAlign: TextAlign.center,
                );
              }
              if (!snapshot.hasData) {
                return const Text(
                  'No meals',
                  textAlign: TextAlign.center,
                );
              }
              if (snapshot.data!.isEmpty) {
                return const Text(
                  'No meals',
                  textAlign: TextAlign.center,
                );
              }
              return AddMealSelect(
                meals: snapshot.data!,
              );
            },
          ),
        ],
      ),
    );
  }
}
