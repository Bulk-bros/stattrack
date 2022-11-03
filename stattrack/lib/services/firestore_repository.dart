import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stattrack/models/user.dart';
import 'package:stattrack/services/repository.dart';
import 'package:stattrack/services/api_paths.dart';

class FirestoreRepository implements Repository {
  @override
  Stream<User?> getUsers(String uid) =>
      _getDocumentStream(ApiPaths.user(uid), User.fromMap);

  @override
  void addUser(User user, String uid) {
    _addDocument({
      'name': user.name,
      'birthday': user.birthday,
      'height': user.height,
      'weight': user.weight,
      'dailyCalories': user.dailyCalories,
      'dailyProteins': user.dailyProteins,
      'dailyFat': user.dailyFat,
    }, 'users', uid);
  }

  Stream<T?> _getDocumentStream<T>(
      String path, T Function(Map<String, dynamic>) fromMap) {
    return FirebaseFirestore.instance
        .doc(path)
        .snapshots()
        .map((snapshot) => snapshot.data())
        .map((document) => document != null ? fromMap(document) : null);
  }

  Future<void> _addDocument(
      Map<String, dynamic> document, String collection, String docId) {
    return FirebaseFirestore.instance
        .collection(collection)
        .doc(docId)
        .set(document)
        .then((value) => print("Document added"))
        .catchError((error) => print("Failed to add document: $error"));
  }
}
