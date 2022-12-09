import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stattrack/services/weight_service.dart';

final weightServiceProvider = Provider<WeightService>((ref) {
  return WeightService();
});
