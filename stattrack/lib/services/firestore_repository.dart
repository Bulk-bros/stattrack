import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stattrack/models/consumed_meal.dart';
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
      'dailyCarbs': user.dailyCarbs,
      'dailyFat': user.dailyFat,
    }, 'users', uid);
  }

  @override
  Stream<List<ConsumedMeal>> getLog(String uid) => _getCollectionStream(
      path: ApiPaths.log(uid),
      fromMap: ConsumedMeal.fromMap,
      sortField: 'time',
      descending: true);

  /// Returns a stream of a collection for the given path
  ///
  /// [path] path to the collection
  /// [fromMap] a function that converts a document in the collection to a model
  /// [sortField] optional. If present the collection will be sorted by this field
  /// [descending] if [sortField] is present, this determines the sort order
  ///              (ascending or descending). False by default
  Stream<List<T>> _getCollectionStream<T>(
      {required String path,
      required T Function(Map<String, dynamic>) fromMap,
      String? sortField,
      bool descending = false}) {
    if (sortField != null) {
      return FirebaseFirestore.instance
          .collection(path)
          .orderBy(sortField, descending: descending)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => fromMap(doc.data())).toList());
    }
    return FirebaseFirestore.instance.collection(path).snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => fromMap(doc.data())).toList());
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
