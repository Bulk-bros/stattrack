import 'package:image_picker/image_picker.dart';
import 'package:stattrack/models/consumed_meal.dart';
import 'package:stattrack/models/ingredient.dart';
import 'package:stattrack/models/user.dart';

import '../models/meal.dart';

abstract class Repository {
  /// Returns a stream with the user that has the user id specified
  /// If no user is found with the given id, a stream of null is returned
  ///
  /// [uid] the user id of the user to find
  Stream<User?> getUsers(String uid);

  /// Adds a user to the database
  ///
  /// [user] the user to add
  /// [uid] the id of the user to add
  void addUser(User user, String uid);

  /// Updates the profile picture path
  ///
  /// [uid] the user where the profile picture path should be updated
  /// [url] the url of the picture to update to
  void updateProfilePicturePath(String uid, String url);

  /// Returns a stream with all ingredients stored for the user
  /// with the given user id
  ///
  /// [uid] the user id of the user the get ingredients for
  Stream<List<Ingredient>?> getIngredients(String uid);

  /// Adds an ingredient to the database
  ///
  /// [ingredient] the ingredient to be added
  /// [uid] the id of the user the meal should be added to
  Future<void> addIngredient(Ingredient ingredient, String uid);

  /// Returns a stream with the all the meals stored for the user with
  /// the given user if
  ///
  /// [uid] the user if of the user to fetch all meals from
  Stream<List<Meal>> getMeals(String uid);

  /// Adds a meal to the database
  ///
  /// [meal] the meal to be added
  /// [uid] the id of the user the meal should be added to
  void addMeal(Meal meal, String uid);

  /// Returns a stream with the consumed meals of the user with the given id
  ///
  /// [uid] the user id of the user to find the consumed meals of
  Stream<List<ConsumedMeal>> getLog(String uid);

  /// Returns a stream with todays consumed meals for a given user
  ///
  /// [uid] the user id of the user to find the consumed meals of
  Stream<List<ConsumedMeal>> getTodaysMeals(String uid);

  /// Adds a meal to the log.
  ///
  /// [meal] the meal to log
  /// [uid] the id of the user to log the meal to
  /// [time] the time the meal was consumed. If not set, the current
  /// time is logged.
  void logMeal({required Meal meal, required String uid, DateTime? time});

  /// Uploads an image to the storage. The url of the image is returned
  /// when the image is uploaded.
  ///
  /// [image] the image to upload
  /// [path] the path to where the image should be uploaded
  Future<String> uploadImage(XFile image, String path);
}
