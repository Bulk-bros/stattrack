import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stattrack/models/user.dart';
import 'package:stattrack/services/repository.dart';
import 'package:stattrack/services/api_paths.dart';

import '../models/ingredient.dart';
import '../models/meal.dart';

class FirestoreRepository implements Repository {
  @override
  Stream<User?> getUsers(String uid) =>
      _getDocumentStream(ApiPaths.user(uid), User.fromMap);

  @override
  Stream<Meal?> getMeals(String mid) =>
      _getDocumentStream(ApiPaths.meal(mid), Meal.fromMap);

  @override
  void addUser(User user, String uid) {
    _addDocument({
      'name': user.name,
      'birthday': user.birthday,
      'height': user.height,
      'weight': user.weight,
      'dailyCalories': user.dailyCalories,
      'dailyProteins': user.dailyProteins,
      'dailyFat': user.dailyFat,
    }, 'users', uid);
  }

  @override
  void addMeal(Meal meal, String uid) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("meals")
        .add({
          'name': meal.name,
          'ingredients': meal.ingredients,
          'instructions': meal.instuctions,
          'calories': meal.calories,
          'proteins': meal.proteins,
          'fat': meal.fat,
          'carbs': meal.carbs,
        })
        .then((value) => print("Meal added"))
        .catchError((error) => print("Error creating meal: $error"));
  }

  Stream<T?> _getDocumentStream<T>(
      String path, T Function(Map<String, dynamic>) fromMap) {
    return FirebaseFirestore.instance
        .doc(path)
        .snapshots()
        .map((snapshot) => snapshot.data())
        .map((document) => document != null ? fromMap(document) : null);
  }

  Future<void> _addDocument(
      Map<String, dynamic> document, String collection, String docId) {
    return FirebaseFirestore.instance
        .collection(collection)
        .doc(docId)
        .set(document)
        .then((value) => print("Document added"))
        .catchError((error) => print("Failed to add document: $error"));
  }
}
