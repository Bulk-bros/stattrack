import 'package:stattrack/models/ingredient.dart';

/// Represents a meal with macros and instructions that a person can eat
class Meal {
  final String name;
  final Map<Ingredient, num>? ingredients;
  final List<String>? instuctions;
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
    return Meal(
      name: document["name"],
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
