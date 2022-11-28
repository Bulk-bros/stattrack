import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stattrack/models/consumed_meal.dart';
import 'package:stattrack/models/ingredient.dart';
import 'package:stattrack/models/user.dart';
import 'package:stattrack/services/repository.dart';
import 'package:stattrack/services/api_paths.dart';
import '../models/meal.dart';

class FirestoreRepository implements Repository {
  @override
  Stream<User?> getUsers(String uid) =>
      _getDocumentStream(ApiPaths.user(uid), User.fromMap);

  @override
  Stream<List<Meal>> getMeals(String uid) {
    return _getCollectionStream(
      path: ApiPaths.meal(uid),
      fromMap: Meal.fromMap,
    );
  }

  @override
  void addUser(User user, String uid) {
    _addDocument(
      document: {
        'name': user.name,
        'profilePicture': user.profilePictureUrl,
        'birthday': user.birthday,
        'height': user.height,
        'weight': user.weight,
        'dailyCalories': user.dailyCalories,
        'dailyProteins': user.dailyProteins,
        'dailyCarbs': user.dailyCarbs,
        'dailyFat': user.dailyFat,
      },
      collection: 'users',
      docId: uid,
    );
  }

  @override
  Future<void> addIngredient(Ingredient ingredient, String uid) =>
      _addDocument(document: {
        'name': ingredient.name,
        'caloriesPer100g': ingredient.caloriesPer100g,
        'proteinsPer100g': ingredient.proteinsPer100g,
        'carbsPer100g': ingredient.carbsPer100g,
        'fatPer100g': ingredient.fatPer100g,
      }, collection: ApiPaths.ingredients(uid));

  @override
  void addMeal(Meal meal, String uid) {
    _addDocument(
      document: {
        'name': meal.name,
        'imageUrl': meal.imageUrl,
        'ingredients': meal.ingredients,
        'instructions': meal.instuctions,
        'calories': meal.calories,
        'proteins': meal.proteins,
        'fat': meal.fat,
        'carbs': meal.carbs,
      },
      collection: ApiPaths.storedMeals(uid),
    );
  }

  @override
  void logMeal({required Meal meal, required String uid, DateTime? time}) =>
      _addDocument(
        document: {
          'name': meal.name,
          'calories': meal.calories,
          'proteins': meal.proteins,
          'carbs': meal.carbs,
          'instructions': meal.instuctions,
          'ingredients': meal.ingredients,
          'fat': meal.fat,
          'time': time ?? DateTime.now(),
          'imageUrl': meal.imageUrl,
        },
        collection: ApiPaths.log(uid),
      );

  @override
  Stream<List<ConsumedMeal>> getLog(String uid) => _getCollectionStream(
      path: ApiPaths.log(uid),
      fromMap: ConsumedMeal.fromMap,
      sortField: 'time',
      descending: true);

  @override
  Stream<List<ConsumedMeal>> getTodaysMeals(String uid) {
    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    return FirebaseFirestore.instance
        .collection(ApiPaths.log(uid))
        .orderBy('time')
        .where('time', isGreaterThan: today)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ConsumedMeal.fromMap(doc.data()))
            .toList());
  }

  // TODO: refactor to general upload that returns the download url
  @override
  Future<void> uploadProfilePicture(XFile image, String uid) async {
    Reference ref = FirebaseStorage.instance.ref().child('$uid/profilepicture');

    await ref.putFile(File(image.path));
    ref.getDownloadURL().then((value) {
      _updateProfileUrlInDatabase(uid, value);
    });
  }

  void _updateProfileUrlInDatabase(String uid, String newUrl) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update(<String, dynamic>{
      'profilePicture': newUrl,
    });
  }

  @override
  Future<String> uploadMealImage(XFile image, String uid) async {
    Reference ref =
        FirebaseStorage.instance.ref().child('$uid/meals/${image.name}');

    await ref.putFile(File(image.path));
    return ref.getDownloadURL();
  }

  @override
  Future<String?> getProfilePictureUrl(String uid) async {
    Reference ref = FirebaseStorage.instance.ref().child(uid);

    return ref.getDownloadURL();
  }

  @override
  Stream<List<Ingredient>?> getIngredients(String uid) =>
      _getCollectionStream<Ingredient>(
          path: ApiPaths.ingredients(uid), fromMap: Ingredient.fromMap);

  /// Returns a stream of a collection for the given path
  ///
  /// [path] path to the collection
  /// [fromMap] a function that converts a document in the collection to a model
  /// [sortField] optional. If present the collection will be sorted by this field
  /// [descending] if [sortField] is present, this determines the sort order
  ///              (ascending or descending). False by default
  Stream<List<T>> _getCollectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic>) fromMap,
    String? sortField,
    bool descending = false,
  }) {
    if (sortField != null) {
      return FirebaseFirestore.instance
          .collection(path)
          .orderBy(sortField, descending: descending)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => fromMap(doc.data())).toList());
    }
    return FirebaseFirestore.instance.collection(path).snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => fromMap(doc.data())).toList());
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
      {required Map<String, dynamic> document,
      required String collection,
      String? docId}) {
    return FirebaseFirestore.instance
        .collection(collection)
        .doc(docId)
        .set(document)
        .then((value) => print("Document added"))
        .catchError((error) => print("Failed to add document: $error"));
  }
}
