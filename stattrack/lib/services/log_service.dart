import 'package:stattrack/models/consumed_meal.dart';
import 'package:stattrack/models/meal.dart';
import 'package:stattrack/repository/firestore_repository.dart';
import 'package:stattrack/repository/repository.dart';
import 'package:stattrack/services/api_paths.dart';
import 'package:uuid/uuid.dart';

class LogService {
  final Repository _repo = FirestoreRepository();

  // Object used to generate random id
  final uuid = const Uuid();

  // Singleton
  static final LogService _logService = LogService._internal();

  factory LogService() {
    return _logService;
  }

  LogService._internal();

  /// Returns a stream containing a list of all meals for the user
  /// with the id given
  ///
  /// [uid] id of the user to get the log of
  Stream<List<ConsumedMeal>> getLog(String uid) {
    return _repo.getCollectionStreamOrderBy(
      path: ApiPaths.log(uid),
      fromMap: ConsumedMeal.fromMap,
      field: 'time',
      descending: true,
    );
  }

  /// Returns a stream containing a list of all meals logged today
  ///
  /// [uid] id of the user to get the log of
  Stream<List<ConsumedMeal>> getTodaysLog(String uid) {
    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    return _repo.getCollectionStreamWhereGreaterThan(
      path: ApiPaths.log(uid),
      fromMap: ConsumedMeal.fromMap,
      field: 'time',
      value: today,
    );
  }

  /// Adds a meal to the log of a user
  ///
  /// [meal] the meal to log
  /// [uid] id of the user to log the meal to
  /// [time] the time the meal was logged (usually the time the meal was consumed).
  /// If not given, current date and time is used.
  Future<void> logMeal(Meal meal, String uid, [DateTime? time]) {
    return _repo.addDocument(
      path: ApiPaths.log(uid),
      document: {
        'id': uuid.v1(),
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
    );
  }

  /// Deletes a consumed meal from the log of a user
  ///
  /// [uid] id of the user to delete the consumed meal from
  /// [mealId] id of the consumed meal to delete
  Future<void> deleteConsumedMeal(String uid, String mealId) {
    return _repo.deleteDocument(path: ApiPaths.consumedMeal(uid, mealId));
  }
}
