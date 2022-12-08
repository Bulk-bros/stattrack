import 'package:stattrack/models/weight.dart';
import 'package:stattrack/repository/firestore_repository.dart';
import 'package:stattrack/repository/repository.dart';
import 'package:stattrack/services/api_paths.dart';

class WeightService {
  final Repository _repo = FirestoreRepository();

  // Singleton
  static final WeightService _weightService = WeightService._internal();

  factory WeightService() {
    return _weightService;
  }

  WeightService._internal();

  /// Returns a stream containins a list with all weights
  /// logged for a user
  ///
  /// [uid] id of the user to return the weights for
  Stream<List<Weight>> getWeights(String uid) {
    return _repo.getCollectionStreamOrderBy(
      path: ApiPaths.weights(uid),
      fromMap: Weight.fromMap,
      field: 'time',
      descending: true,
    );
  }

  /// TODO: Fix so it only returns current months weights!!!
  Stream<List<Weight>> getWeightsThisMonth(String uid) {
    return _repo.getCollectionStream(
      path: ApiPaths.weights(uid),
      fromMap: Weight.fromMap,
    );
  }

  /// Loggs a new weight to a user
  ///
  /// [weight] the weight to log
  /// [uid] id of the user to log the weight to
  Future<void> logWeight(Weight weight, String uid) {
    return _repo.addDocument(
      path: ApiPaths.weights(uid),
      document: {
        'weight': weight.value,
        'time': weight.time,
      },
    );
  }
}
