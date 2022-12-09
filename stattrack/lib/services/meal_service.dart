import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:stattrack/models/meal.dart';
import 'package:stattrack/repository/firestore_repository.dart';
import 'package:stattrack/repository/repository.dart';
import 'package:stattrack/services/api_paths.dart';
import 'package:uuid/uuid.dart';

class MealService {
  final Repository _repo = FirestoreRepository();

  // Object used to generate random id
  final uuid = const Uuid();

  // Singleton
  static final MealService _mealService = MealService._internal();

  factory MealService() {
    return _mealService;
  }

  MealService._internal();

  /// Returns a stream containing all the meals stored on the user
  /// with the id given
  ///
  /// [uid] id of the user
  Stream<List<Meal>> getMeals(String uid) {
    return _repo.getCollectionStream<Meal>(
      path: ApiPaths.meals(uid),
      fromMap: Meal.fromMap,
    );
  }

  /// Adds a meal to a user
  ///
  /// Two optional params. [imageData] and [imageFile], only one can
  /// be provided.
  ///
  /// [meal] the meal to add
  /// [uid] id of the user to add the meal to
  /// [imageData] the data of the image to store for the meal
  /// [imageFile] the image file of the image to store for the meal
  Future<void> addMeal({
    required Meal meal,
    required String uid,
    Uint8List? imageData,
    File? imageFile,
  }) async {
    if (imageData != null && imageFile != null) {
      throw Exception('Two image types not accepted. Please only provide one');
    }
    if (imageData == null && imageFile == null) {
      throw Exception('Needs to provide at least one image for the meal');
    }

    String imageUrl = '';
    // Upload image
    if (imageData != null) {
      imageUrl = await _repo.uploadFileFromData(
        path: ApiPaths.mealImage(uid, uuid.v1()),
        data: imageData,
      );
    }
    if (imageFile != null) {
      imageUrl = await _repo.uploadFile(
        path: ApiPaths.mealImage(uid, uuid.v1()),
        file: imageFile,
      );
    }

    // Upload document
    await _repo.addDocument(
      path: ApiPaths.meals(uid),
      document: {
        'id': meal.id,
        'name': meal.name,
        'imageUrl': imageUrl,
        'ingredients': meal.ingredients,
        'instructions': meal.instuctions,
        'calories': meal.calories,
        'proteins': meal.proteins,
        'fat': meal.fat,
        'carbs': meal.carbs,
      },
      docId: meal.id,
    );
  }

  /// Deletes a meal from a user
  ///
  /// [uid] id of the user to delete the meal from
  /// [meal] id of the meal to delete
  Future<void> deleteMeal(String uid, Meal meal) async {
    await _repo.deleteDocument(path: ApiPaths.meal(uid, meal.id));
  }
}
