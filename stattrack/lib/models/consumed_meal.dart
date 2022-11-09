import 'package:stattrack/models/meal.dart';

/// Represents a meal that is consumed by a user
class ConsumedMeal {
  final String name;
  final DateTime time;
  final num calories;
  final num protein;
  final num carbs;
  final num fat;

  ConsumedMeal({
    required this.name,
    required this.time,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  @override
  String toString() {
    return 'ConsumedMeal(name: $name, time: $time, calories: $calories, protein: $protein, carbs: $carbs, fat: $fat)';
  }
}
