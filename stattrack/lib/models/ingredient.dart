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

  @override
  String toString() {
    return 'Ingredient{name: $name, caloriesPer100g: $caloriesPer100g, proteinsPer100g: $proteinsPer100g, fatPer100g: $fatPer100g, carbsPer100g: $carbsPer100g}';
  }
}
