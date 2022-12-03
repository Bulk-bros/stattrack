import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents a user in the application
/// [name] name of the user
/// [profilePictureUrl] the url of the profile picture related to the user
/// [height] height of a user
/// [birthday] birthdate of a user
/// [dailyCalories] the amount of calories wanted to be consumed daily
/// [dailyProteins] the amount of proteins wanted ot be consumed daily
/// [dailyCarbs] the amount of carbohydrates wanted to be consumed daily
/// [dailyFat] the amount of fat wanted to be consumed daily
///
class User {
  final String name;
  final String profilePictureUrl;
  final num height;
  final Timestamp birthday;
  final num dailyCalories;
  final num dailyProteins;
  final num dailyCarbs;
  final num dailyFat;

  User({
    required this.name,
    required this.profilePictureUrl,
    required this.height,
    required this.birthday,
    required this.dailyCalories,
    required this.dailyProteins,
    required this.dailyCarbs,
    required this.dailyFat,
  });

  /// Returns the age of the user
  int getAge() {
    return DateTime.now().difference(birthday.toDate()).inDays ~/ 365;
  }

  /// Converts a document object from firestore to a User object
  ///
  /// [document] the document object retrieved from firestore
  static User fromMap(Map<String, dynamic> document) {
    return User(
        name: document["name"],
        profilePictureUrl: document["profilePicture"],
        height: document["height"],
        birthday: document["birthday"],
        dailyCalories: document["dailyCalories"],
        dailyProteins: document["dailyProteins"],
        dailyCarbs: document["dailyCarbs"],
        dailyFat: document["dailyFat"]);
  }

  @override
  String toString() {
    return 'User{name: $name, height: $height, birthday: $birthday, dailyCalories: $dailyCalories, dailyProteins: $dailyProteins, dailyFat: $dailyFat}';
  }
}
