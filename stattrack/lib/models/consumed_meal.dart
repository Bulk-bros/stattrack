/// Represents a meal that is consumed by a user
class ConsumedMeal {
  final String name;
  final DateTime time;
  final num calories;
  final num proteins;
  final num carbs;
  final num fat;
  final String? imageUrl;

  ConsumedMeal({
    required this.name,
    required this.time,
    required this.calories,
    required this.proteins,
    required this.carbs,
    required this.fat,
    this.imageUrl,
  });

  /// converts a document object from firestore to a ConsumedMeal object
  static ConsumedMeal fromMap(Map<String, dynamic> document) {
    return ConsumedMeal(
        name: document["name"],
        time: document["time"].toDate(),
        calories: document["calories"],
        proteins: document["proteins"],
        carbs: document["carbs"],
        fat: document["fat"]);
  }

  @override
  String toString() {
    return 'ConsumedMeal(name: $name, time: $time, calories: $calories, protein: $proteins, carbs: $carbs, fat: $fat)';
  }
}
