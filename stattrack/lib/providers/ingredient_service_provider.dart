import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stattrack/services/ingredient_service.dart';

final ingredientServiceProvider = Provider<IngredientService>((ref) {
  return IngredientService();
});
