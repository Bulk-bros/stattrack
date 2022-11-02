class User {
  final String name;
  final num weight;
  final num height;
  final DateTime age;
  final num dailyCalories;
  final num dailyProteins;
  final num dailyFat;

  User({
    required this.name,
    required this.weight,
    required this.height,
    required this.age,
    required this.dailyCalories,
    required this.dailyProteins,
    required this.dailyFat,
  });

  /// Converts a document object from firestore to a User object
  ///
  /// [document] the document object retrieved from firestore
  static User fromMap(Map<String, dynamic> document) {
    return User(
        name: document["name"],
        weight: document["weight"],
        height: document["height"],
        age: document["age"],
        dailyCalories: document["dailyCalories"],
        dailyProteins: document["dailyProteins"],
        dailyFat: document["dailyFat"]);
  }

  @override
  String toString() {
    return 'User{name: $name, weight: $weight, height: $height, age: $age, dailyCalories: $dailyCalories, dailyProteins: $dailyProteins, dailyFat: $dailyFat}';
  }
}
