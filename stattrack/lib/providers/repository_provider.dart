import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stattrack/repository/firestore_repository.dart';
import 'package:stattrack/repository/repository.dart';

final repositoryProvider = Provider<Repository>((ref) {
  return FirestoreRepository();
});
