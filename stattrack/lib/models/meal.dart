import 'dart:convert';

import 'package:stattrack/models/IngredientAmount.dart';
import 'package:stattrack/models/ingredient.dart';

/// Represents a meal with macros and instructions that a person can eat
class Meal {
  final String name;
  final Map<String?, num>? ingredients;
  final List<String?>? instuctions;
  final num calories;
  final num proteins;
  final num fat;
  final num carbs;

  Meal({
    required this.name,
    this.ingredients,
    this.instuctions,
    required this.calories,
    required this.proteins,
    required this.fat,
    required this.carbs,
  });

  /// Converts a document object from firestore to a Meal object
  ///
  /// [document] the document object retrieved from firestore
  static Meal fromMap(Map<String, dynamic> document) {
    // Convert firebase ingredients to map of ingredients with amount
    String ingredientsString = document['ingredients'].toString();
    List<String> ingredientList = ingredientsString
        .substring(1, ingredientsString.length - 1)
        .split(', ');
    Map<String?, num> ingredients = {};
    ingredientList.forEach((element) {
      ingredients[element.split(': ').first] =
          num.parse(element.split(': ').last);
    });

    // Convert firebase instructions to list of instructions
    String instructionsString = document['instructions'].toString();
    List<String> instructions = instructionsString
        .substring(1, instructionsString.length - 1)
        .split(', ');

    return Meal(
      name: document["name"],
      ingredients: ingredients,
      instuctions: instructions,
      calories: document["calories"],
      proteins: document["proteins"],
      fat: document["fat"],
      carbs: document["carbs"],
    );
  }

  @override
  String toString() {
    return 'Meal{name: $name, ingredients: $ingredients, instuctions: $instuctions, calories: $calories, proteins: $proteins, fat: $fat, carbs: $carbs}';
  }
}
