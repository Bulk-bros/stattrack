import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:stattrack/components/create_meal.dart';
import 'package:stattrack/components/meal_card.dart';
import 'package:stattrack/models/meal.dart';
import 'package:stattrack/styles/palette.dart';

import '../styles/font_styles.dart';

// FIXME: Stream created for testing injection of stream without fetching from firestore.
// Replace the stream in the streambuilder with the one you get when creating fetch method
// and delete this class.
class MealController {
  final List<Meal> meals = [
    Meal(
      id: "1",
      name: 'Salad',
      calories: 500,
      proteins: 20,
      fat: 5,
      carbs: 100,
    ),
    Meal(
      id: "2",
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

class AddMeal extends StatefulWidget {
  const AddMeal({Key? key}) : super(key: key);

  @override
  _AddMealState createState() => _AddMealState();
}

class _AddMealState extends State<AddMeal> {
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
  void _addMeal() {
    print("Adding meal with name: ${activeMeal!.name}");
  }

  /// Handles the search event
  ///
  /// [searchWord] the word to seach for
  void _handleSearch(String searchWord) {
    print(searchWord);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: Colors.white,
      ),
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
            height: 20.0,
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
          Flexible(
            child: SingleChildScrollView(
              child: StreamBuilder<List<Meal>>(
                stream: mealController.getController().stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.active) {
                    return const Text('No connection');
                  }
                  if (!snapshot.hasData) {
                    return const Text('No data');
                  }
                  if (snapshot.data!.isEmpty) {
                    return const Text('No meals');
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ...snapshot.data!.map((meal) {
                        return MealCard(
                          meal: meal,
                          onPressed: (meal) => _handleMealCardPressed(meal),
                          backgroundColor:
                              activeMeal == meal ? Palette.accent[400] : null,
                          color: activeMeal == meal ? Colors.white : null,
                        );
                      })
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            onPressed: activeMeal == null ? null : _addMeal,
            style: ElevatedButton.styleFrom(
              backgroundColor: Palette.accent[400],
              elevation: 8.0,
            ),
            child: const Text(
              "Add",
              style: TextStyle(
                  fontSize: FontStyles.fsBody,
                  fontWeight: FontStyles.fw500,
                  color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
