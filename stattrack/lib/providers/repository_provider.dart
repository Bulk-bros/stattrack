import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stattrack/services/firestore_repository.dart';
import 'package:stattrack/services/repository.dart';

final repositoryProvider = Provider<Repository>((ref) {
  return FirestoreRepository();
});
