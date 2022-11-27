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
  void updateWeight(String uid, num value) =>
      _updateDocumentField('users/$uid', 'weight', value);

  @override
  void updateDailyCalorieConsumption(String uid, num value) =>
      _updateDocumentField('users/$uid', 'dailyCalories', value);

  @override
  void updateDailyProteinConsumption(String uid, num value) =>
      _updateDocumentField('users/$uid', 'dailyProteins', value);

  @override
  void updateDailyCarbsConsumption(String uid, num value) =>
      _updateDocumentField('users/$uid', 'dailyCarbs', value);

  @override
  void updateDailyFatConsumption(String uid, num value) =>
      _updateDocumentField('users/$uid', 'dailyFat', value);

  @override
  void updateProfilePicturePath(String uid, String url) =>
      _updateDocumentField('users/$uid', 'profilePicture', 'url');

  @override
  Stream<List<Ingredient>?> getIngredients(String uid) =>
      _getCollectionStream<Ingredient>(
          path: ApiPaths.ingredients(uid), fromMap: Ingredient.fromMap);

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
  Stream<List<Meal>> getMeals(String uid) {
    return _getCollectionStream(
      path: ApiPaths.meal(uid),
      fromMap: Meal.fromMap,
    );
  }

  @override
  void addMeal(Meal meal, String uid) {
    _addDocument(
      document: {
        'id': meal.id,
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
      docId: meal.id,
    );
  }

  @override
  Future<void> deleteMeal(String uid, String mealId) =>
      _deleteDocument('users/$uid/meals/$mealId');

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

  @override
  void logMeal({required Meal meal, required String uid, DateTime? time}) =>
      _addDocument(
        document: {
          'name': meal.name,
          'calories': meal.calories,
          'proteins': meal.proteins,
          'carbs': meal.carbs,
          'fat': meal.fat,
          'time': time ?? DateTime.now(),
        },
        collection: ApiPaths.log(uid),
      );

  @override
  Future<String> uploadImage(XFile image, String path) async {
    Reference ref = FirebaseStorage.instance.ref().child(path);

    await ref.putFile(File(image.path));
    return ref.getDownloadURL();
  }

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

  /// Returns a stream of an object of type T, based on a document stored
  /// in the firestore
  ///
  /// [path] path to the document
  /// [fromMap] a function that converts the document to an object of type T
  Stream<T?> _getDocumentStream<T>(
      String path, T Function(Map<String, dynamic>) fromMap) {
    return FirebaseFirestore.instance
        .doc(path)
        .snapshots()
        .map((snapshot) => snapshot.data())
        .map((document) => document != null ? fromMap(document) : null);
  }

  /// Adds a document to the firestore
  ///
  /// [document] the document to be added
  /// [collection] a path to the collection the document should be added to
  /// [docId] if given, the document will get this id. If no, a random id will
  /// be given
  Future<void> _addDocument({
    required Map<String, dynamic> document,
    required String collection,
    String? docId,
  }) {
    return FirebaseFirestore.instance
        .collection(collection)
        .doc(docId)
        .set(document)
        .then((value) => print("Document added"))
        .catchError((error) => print("Failed to add document: $error"));
  }

  /// Updates the field of a document
  ///
  /// [path] the path to the document that should be updated
  /// [field] the field in the specified document that shoud be updated
  /// [value] the value that should be replaced in the field
  Future<void> _updateDocumentField(String path, String field, dynamic value) {
    return FirebaseFirestore.instance.doc(path).update(<String, dynamic>{
      field: value,
    });
  }

  /// Deletes a document
  ///
  /// [path] the path to the document to be deleted
  Future<void> _deleteDocument(String path) {
    return FirebaseFirestore.instance.doc(path).delete();
  }
}
