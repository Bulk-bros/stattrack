import 'package:stattrack/models/ingredient.dart';
import 'package:stattrack/repository/firestore_repository.dart';
import 'package:stattrack/repository/repository.dart';
import 'package:stattrack/services/api_paths.dart';

class IngredientService {
  final Repository _repo = FirestoreRepository();

  // Singleton
  static final IngredientService _ingredientService =
      IngredientService._internal();

  factory IngredientService() {
    return _ingredientService;
  }

  IngredientService._internal();

  /// Returns a stream containint a list of all ingredients
  /// stored for the user with the id given
  ///
  /// [uid] id of the user to get the ingredients for
  Stream<List<Ingredient>> getIngredients(String uid) {
    return _repo.getCollectionStream(
      path: ApiPaths.ingredients(uid),
      fromMap: Ingredient.fromMap,
    );
  }

  /// Adds an ingredient to a user
  ///
  /// [ingredient] the ingredient to add
  /// [uid] id of the user to add the ingredient to
  Future<void> addIngredient(Ingredient ingredient, String uid) {
    return _repo.addDocument(
      path: ApiPaths.ingredients(uid),
      document: {
        'name': ingredient.name,
        'unit': ingredient.unit,
        'caloriesPerUnit': ingredient.caloriesPerUnit,
        'proteinsPerUnit': ingredient.proteinsPerUnit,
        'carbsPerUnit': ingredient.carbsPerUnit,
        'fatPerUnit': ingredient.fatPerUnit,
        'saturatedFatPerUnit': ingredient.saturatedFatPerUnit,
        'saltPerUnit': ingredient.saltPerUnit,
        'sugarPerUnit': ingredient.sugarsPerUnit,
      },
    );
  }
}
