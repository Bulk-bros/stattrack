/// Represents a meal with macros and instructions that a person can eat

/// [id] the id of the consumed meal
/// [name] consumed meal title
/// [calories] the total amount of calories in the meal
/// [proteins] the total amount of proteins in the meal
/// [fat] the total amount of fat in the meal
/// [carbs] the total amount of carbohydrates in the meal
/// [ingredients] a list of the ingredients for the meal
/// [instuctions] a list of instructions for the meal
/// [imageUrl] the url for the image related to the meal
class Meal {
  final String id;
  final String name;
  final String imageUrl;
  final Map<String?, num> ingredients;
  final List<dynamic>? instuctions;
  final num calories;
  final num proteins;
  final num fat;
  final num carbs;

  Meal({
    required this.id,
    required this.name,
    required this.imageUrl,
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
    Map<String?, num> ingredients = {};
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
