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

  /// Adds an ingredient to the database
  ///
  /// [ingredient] the ingredient to be added
  /// [uid] the id of the user the meal should be added to
  Future<void> addIngredient(Ingredient ingredient, String uid);

  /// Adds a meal to the database
  ///
  /// [meal] the meal to be added
  /// [uid] the id of the user the meal should be added to
  void addMeal(Meal meal, String uid);

  /// Returns a stream with the all the meals stored for the user with
  /// the given user if
  ///
  /// [uid] the user if of the user to fetch all meals from
  Stream<List<Meal>> getMeals(String uid);

  /// Returns a stream with the consumed meals of the user with the given id
  ///
  /// [uid] the user id of the user to find the consumed meals of
  Stream<List<ConsumedMeal>> getLog(String uid);

  Stream<List<ConsumedMeal>> getTodaysMeals(String uid);

  /// Uploads a profile picture to the cloud
  ///
  /// [image] the image to upload
  /// [uid] the id of the user to upload the image for
  Future<void> uploadProfilePicture(XFile image, String uid);

  /// Returns the url for the profile picture of the user with the given
  /// user id
  ///
  /// [uid] the user id to get the profile picture url for
  Future<String?> getProfilePictureUrl(String uid);

  /// Adds a meal to the log.
  ///
  /// [meal] the meal to log
  /// [uid] the id of the user to log the meal to
  /// [time] the time the meal was consumed. If not set, the current
  /// time is logged.
  void logMeal({required Meal meal, required String uid, DateTime? time});

  /// Returns a stream with all ingredients stored for the user
  /// with the given user id
  ///
  /// [uid] the user id of the user the get ingredients for
  Stream<List<Ingredient>?> getIngredients(String uid);
}
