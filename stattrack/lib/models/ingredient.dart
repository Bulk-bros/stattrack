/// Represents a ingredeint that is used in meals
class Ingredient {
  final String name;
  final String unit;
  final num caloriesPerUnit;
  final num proteinsPerUnit;
  final num fatPerUnit;
  final num carbsPerUnit;
  final num saltPerUnit;
  final num saturatedFatPerUnit;
  final num sugarsPerUnit;

  Ingredient({
    required this.name,
    required this.unit,
    required this.caloriesPerUnit,
    required this.proteinsPerUnit,
    required this.fatPerUnit,
    required this.carbsPerUnit,
    required this.saltPerUnit,
    required this.saturatedFatPerUnit,
    required this.sugarsPerUnit,
  });

  static Ingredient fromMap(Map<String, dynamic> document) {
    return Ingredient(
      name: document['name'],
      unit: document['unit'],
      caloriesPerUnit: document['caloriesPerUnit'],
      proteinsPerUnit: document['proteinsPerUnit'],
      fatPerUnit: document['fatPerUnit'],
      carbsPerUnit: document['carbsPerUnit'],
      saltPerUnit: document['saltPerUnit'],
      saturatedFatPerUnit: document['saturatedFatPerUnit'],
      sugarsPerUnit: document['sugarsPerUnit'],
    );
  }

  @override
  String toString() {
    return 'Ingredient{name: $name, caloriesPer100g: $caloriesPerUnit, proteinsPerUnit: $proteinsPerUnit, fatPerUnit: $fatPerUnit, carbsPerUnit: $carbsPerUnit, saltPerUnit : $saltPerUnit, saturatedFatPerUnit: $saturatedFatPerUnit, sugarsPerUnit: $sugarsPerUnit}';
  }

  @override
  bool operator ==(dynamic other) =>
      other != null &&
      other is Ingredient &&
      other.name == name &&
      other.unit == unit &&
      other.caloriesPerUnit == caloriesPerUnit &&
      other.proteinsPerUnit == proteinsPerUnit &&
      other.fatPerUnit == fatPerUnit &&
      other.carbsPerUnit == carbsPerUnit &&
      other.saltPerUnit == saltPerUnit &&
      other.saturatedFatPerUnit == saturatedFatPerUnit &&
      other.sugarsPerUnit == sugarsPerUnit;

  @override
  int get hashCode => super.hashCode;

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> product = json["product"];
    final Map<String, dynamic> nutriments = product["nutriments"];
    final dynamic calories = num.parse('${nutriments["energy-kcal_100g"]}');
    print(calories);
    try {
      return Ingredient(
          name: product["product_name"],
          unit: '100g',
          caloriesPerUnit: num.parse('${nutriments["energy-kcal_100g"]}'),
          proteinsPerUnit: num.parse('${nutriments["proteins_100g"]}'),
          fatPerUnit: num.parse('${nutriments["fat_100g"]}'),
          carbsPerUnit: num.parse('${nutriments["carbohydrates_100g"]}'),
          saltPerUnit: num.parse('${nutriments["salt_100g"]}'),
          saturatedFatPerUnit: num.parse('${nutriments["saturated-fat_100g"]}'),
          sugarsPerUnit: num.parse('${nutriments["sugars_100g"]}'));
    } catch (e) {
      throw Exception('Could not convert json to ingredient');
    }
  }
}
