import 'package:stattrack/models/meal.dart';

/// Represents a meal that is consumed by a user
class ConsumedMeal {
  final Meal meal;
  final DateTime time;

  ConsumedMeal({
    required this.meal,
    required this.time,
  });

  @override
  String toString() {
    return 'LogItem{meal: $meal, time: $time}';
  }
}
