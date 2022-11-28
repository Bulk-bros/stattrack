/// Represents a ingredeint that is used in meals
class Ingredient {
  final String name;
  final num caloriesPer100g;
  final num proteinsPer100g;
  final num fatPer100g;
  final num carbsPer100g;

  Ingredient({
    required this.name,
    required this.caloriesPer100g,
    required this.proteinsPer100g,
    required this.fatPer100g,
    required this.carbsPer100g,
  });

  static Ingredient fromMap(Map<String, dynamic> document) {
    return Ingredient(
        name: document['name'],
        caloriesPer100g: document['caloriesPer100g'],
        proteinsPer100g: document['proteinsPer100g'],
        fatPer100g: document['fatPer100g'],
        carbsPer100g: document['carbsPer100g']);
  }

  @override
  String toString() {
    return 'Ingredient{name: $name, caloriesPer100g: $caloriesPer100g, proteinsPer100g: $proteinsPer100g, fatPer100g: $fatPer100g, carbsPer100g: $carbsPer100g}';
  }

  @override
  bool operator ==(dynamic other) =>
      other != null &&
      other is Ingredient &&
      other.name == name &&
      other.caloriesPer100g == caloriesPer100g &&
      other.proteinsPer100g == proteinsPer100g &&
      other.fatPer100g == fatPer100g &&
      other.carbsPer100g == carbsPer100g;

  @override
  int get hashCode => super.hashCode;
}
