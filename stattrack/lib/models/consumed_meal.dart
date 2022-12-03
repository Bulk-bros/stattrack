import 'package:stattrack/models/meal.dart';

/// Represents a meal that is consumed by a user
/// [id] the id of the consumed meal
/// [name] consumed meal title
/// [calories] the total amount of calories in the meal
/// [proteins] the total amount of proteins in the meal
/// [fat] the total amount of fat in the meal
/// [carbs] the total amount of carbohydrates in the meal
/// [time] the time the meal was consumed
/// [ingredients] a list of the ingredients for the meal
/// [instuctions] a list of instructions for the meal
/// [imageUrl] the url for the image related to the meal
class ConsumedMeal extends Meal {
  @override
  ConsumedMeal({
    required super.id,
    required super.name,
    required super.calories,
    required super.proteins,
    required super.fat,
    required super.carbs,
    required this.time,
    required super.ingredients,
    super.instuctions,
    required super.imageUrl,
  });

  final DateTime time;

// final String name;
  // final DateTime time;
  // final num calories;
  // final num proteins;
  // final num carbs;
  // final num fat;
  // final String? imageUrl;

  // ConsumedMeal({
  //   required this.name,
  //   required this.time,
  //   required this.calories,
  //   required this.proteins,
  //   required this.carbs,
  //   required this.fat,
  //   this.imageUrl,
  // });

  /// converts a document object from firestore to a ConsumedMeal object
  static ConsumedMeal fromMap(Map<String, dynamic> document) {
    // Convert firebase ingredients to map of ingredients with amount
    String ingredientsString = document['ingredients'].toString();
    List<String> ingredientList = ingredientsString
        .substring(1, ingredientsString.length - 1)
        .split(', ');
    Map<String?, num> ingredients = {};
    for (var element in ingredientList) {
      ingredients[element.split(': ').first] =
          num.parse(element.split(': ').last);
    }

    return ConsumedMeal(
        id: document["id"],
        name: document["name"],
        time: document["time"].toDate(),
        calories: document["calories"],
        proteins: document["proteins"],
        carbs: document["carbs"],
        fat: document["fat"],
        instuctions: document['instructions'],
        ingredients: ingredients,
        imageUrl: document["imageUrl"]);
  }

  @override
  String toString() {
    return 'ConsumedMeal(name: $name, time: $time, calories: $calories, protein: $proteins, carbs: $carbs, fat: $fat)';
  }
}
