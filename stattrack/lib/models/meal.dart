/// Represents a meal with macros and instructions that a person can eat
class Meal {
  final String id;
  final String name;
  final String? imageUrl;
  final Map<String, num> ingredients;
  final List<dynamic>? instuctions;
  final num calories;
  final num proteins;
  final num fat;
  final num carbs;

  Meal({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.ingredients,
    required this.instuctions,
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
    Map<String, num> ingredients = {};
    for (var element in ingredientList) {
      ingredients[element.split(': ').first] =
          num.parse(element.split(': ').last);
    }

    return Meal(
      id: document["id"],
      name: document["name"],
      imageUrl: document["imageUrl"],
      ingredients: ingredients,
      instuctions: document['instructions'],
      calories: num.parse(document["calories"].toString().split('.').first),
      proteins: num.parse(document["proteins"].toString().split('.').first),
      fat: num.parse(document["fat"].toString().split('.').first),
      carbs: num.parse(document["carbs"].toString().split('.').first),
    );
  }

  @override
  String toString() {
    return 'Meal{name: $name, ingredients: $ingredients, instuctions: $instuctions, calories: $calories, proteins: $proteins, fat: $fat, carbs: $carbs}';
  }
}
