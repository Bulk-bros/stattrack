import 'package:stattrack/models/ingredient.dart';

/// Represents a meal with macros and instructions that a person can eat
class Meal {
  final String id;
  final String name;
  final Map<Ingredient, num>? ingredients;
  final List<String>? instuctions;
  final num calories;
  final num proteins;
  final num fat;
  final num carbs;

  Meal({
    required this.id,
    required this.name,
    this.ingredients,
    this.instuctions,
    required this.calories,
    required this.proteins,
    required this.fat,
    required this.carbs,
  });

  @override
  String toString() {
    return 'Meal{name: $name, ingredients: $ingredients, instuctions: $instuctions}';
  }
}
