import 'dart:io';

import 'package:stattrack/models/meal.dart';
import 'package:stattrack/models/user.dart';
import 'package:stattrack/models/weight.dart';
import 'package:stattrack/repository/firestore_repository.dart';
import 'package:stattrack/repository/repository.dart';
import 'package:stattrack/services/api_paths.dart';

class UserService {
  final Repository _repo = FirestoreRepository();

  /// Returns a stream of a user
  ///
  /// [uid] id of the user to return
  Stream<User?> getUser(String uid) {
    return _repo.getDocumentStream<User>(
      path: ApiPaths.user(uid),
      fromMap: User.fromMap,
    );
  }

  /// Adds a user to the database
  ///
  /// [user] the user to add
  /// [profilePicture] if provided this file is uploaded and stored
  /// as the user profile picture
  /// [weight] the current weight of the user
  /// [uid] the id of the user
  Future<void> addUser({
    required User user,
    File? profilePicture,
    required Weight weight,
    required String uid,
  }) async {
    // Upload profile image if provided
    String? profilePictureUrl;
    if (profilePicture != null) {
      profilePictureUrl = await _repo.uploadFile(
        path: ApiPaths.profilePicture(uid),
        file: profilePicture,
      );
    }

    // Add the user
    await _repo.addDocument(
      path: ApiPaths.users(),
      document: {
        'name': user.name,
        'profilePicture': profilePictureUrl,
        'birthday': user.birthday,
        'height': user.height,
        'dailyCalories': user.dailyCalories,
        'dailyProteins': user.dailyProteins,
        'dailyCarbs': user.dailyCarbs,
        'dailyFat': user.dailyFat,
      },
      docId: uid,
    );

    // Add the current weight to the users logged weights collection
    await _repo.addDocument(
      path: ApiPaths.weights(uid),
      document: {
        'weight': weight.value,
        'time': weight.time,
      },
    );
  }

  /// Deletes a user from the database
  ///
  /// [uid] id of the user to delete
  Future<void> deleteUser(String uid) async {
    User? user = await getUser(uid).first;

    if (user == null) return;

    // Delete profile image
    if (user.profilePictureUrl != null) {
      await _repo.deleteFile(url: user.profilePictureUrl!);
    }

    // Delete meal images
    // TODO: replace _repo.getMeals with mealService.getMeals when that is
    // implemented
    List<Meal> meals = await _repo.getMeals(uid).first;
    for (var meal in meals) {
      await _repo.deleteFile(url: meal.imageUrl);
    }

    // Delete user log
    await _repo.deleteCollection(path: ApiPaths.log(uid));
    // Delete users ingredients
    await _repo.deleteCollection(path: ApiPaths.ingredients(uid));
    // Delete users weight log
    await _repo.deleteCollection(path: ApiPaths.weights(uid));
    // Delete users meals
    await _repo.deleteCollection(path: ApiPaths.meals(uid));

    // Delete user
    await _repo.deleteDocument(path: ApiPaths.user(uid));
  }
}
