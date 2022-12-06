import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stattrack/models/user.dart';
import 'package:stattrack/providers/repository_provider.dart';
import 'package:stattrack/repository/firestore_repository.dart';
import 'package:stattrack/repository/repository.dart';
import 'package:stattrack/services/api_paths.dart';

class UserService {
  final Repository _repo = FirestoreRepository();

  Stream<User?> getUser(String uid) {
    return _repo.getDocumentStream<User>(
      path: ApiPaths.user(uid),
      fromMap: User.fromMap,
    );
  }
}
