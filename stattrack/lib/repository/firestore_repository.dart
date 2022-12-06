import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stattrack/models/consumed_meal.dart';
import 'package:stattrack/models/ingredient.dart';
import 'package:stattrack/models/user.dart';
import 'package:stattrack/models/weight.dart';
import 'package:stattrack/repository/repository.dart';
import 'package:stattrack/services/api_paths.dart';
import '../models/meal.dart';
import 'package:path/path.dart' as Path;

/// A class describing all the filter options available with firebase firestore
///
/// [field] the filed to filter after
/// [isEqualTo] a value the field has to be equal to
/// [isLessThan] a value the field has to be less than
/// [isLessThanOrEqualTo] a value the field has to be less or equal to
/// [isGreaterThan] a value the field has to be greater than
/// [isGreaterThanOrEqualTo] a value the field has to be greater than or equal to
class Predicate {
  final String field;
  final Object? isEqualtTo;
  final Object? isLessThan;
  final Object? isLessThanOrEqualTo;
  final Object? isGreaterThan;
  final Object? isGreaterThanOrEqualTo;
  final Object? arrayContains;
  final List<Object?>? arrayContainsAny;
  final List<Object?>? whereIn;
  final List<Object?>? whereNotIn;
  final Object? isNull;

  Predicate(
    this.field, {
    this.isEqualtTo,
    this.isLessThan,
    this.isLessThanOrEqualTo,
    this.isGreaterThan,
    this.isGreaterThanOrEqualTo,
    this.arrayContains,
    this.arrayContainsAny,
    this.whereIn,
    this.whereNotIn,
    this.isNull,
  });
}

/// Exposes generic methods for CRUD operations to firestore
class FirestoreRepository implements Repository {
  // Singleton
  static final FirestoreRepository _firestoreRepository =
      FirestoreRepository._internal();

  factory FirestoreRepository() {
    return _firestoreRepository;
  }

  FirestoreRepository._internal();

  @override
  Stream<T?> getDocumentStream<T>({
    required String path,
    required T Function(Map<String, dynamic>) fromMap,
  }) {
    return FirebaseFirestore.instance
        .doc(path)
        .snapshots()
        .map((snapshot) => snapshot.data())
        .map((document) => document != null ? fromMap(document) : null);
  }

  @override
  Future<void> addDocument<T>({
    required String path,
    required Map<String, dynamic> document,
    String? docId,
  }) {
    return FirebaseFirestore.instance.collection(path).doc(docId).set(document);
  }

  @override
  Future<void> updateDocumentField({
    required String path,
    required String field,
    required dynamic value,
  }) {
    return FirebaseFirestore.instance.doc(path).update(<String, dynamic>{
      field: value,
    });
  }

  @override
  Future<void> deleteDocument({
    required String path,
  }) {
    return FirebaseFirestore.instance.doc(path).delete();
  }

  @override
  Stream<List<T>> getCollectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic>) fromMap,
  }) {
    return FirebaseFirestore.instance.collection(path).snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => fromMap(doc.data())).toList());
  }

  // TODO: Revisit and research if you can create a more general method
  // that takes in a predicate instead
  @override
  Stream<List<T>> getCollectionStreamWhereGreaterThan<T>({
    required String path,
    required T Function(Map<String, dynamic>) fromMap,
    required String field,
    required dynamic value,
  }) {
    return FirebaseFirestore.instance
        .collection(path)
        .where(field, isGreaterThan: value)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => fromMap(doc.data())).toList());
  }

  @override
  Stream<List<T>> getCollectionStreamOrderBy<T>({
    required String path,
    required T Function(Map<String, dynamic>) fromMap,
    required String field,
    bool descending = false,
  }) {
    return FirebaseFirestore.instance
        .collection(path)
        .orderBy(field, descending: descending)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => fromMap(doc.data())).toList());
  }

  @override
  Future<void> deleteCollection({
    required String path,
  }) {
    return FirebaseFirestore.instance.collection(path).get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }

  @override
  Future<String> uploadFile({
    required String path,
    required File file,
  }) async {
    Reference ref = FirebaseStorage.instance.ref().child(path);
    await ref.putFile(file);
    return ref.getDownloadURL();
  }

  @override
  Future<String> uploadFileFromData({
    required String path,
    required Uint8List data,
  }) async {
    Reference ref = FirebaseStorage.instance.ref().child(path);
    await ref.putData(data);
    return ref.getDownloadURL();
  }

  @override
  Future<Uint8List?> getFileAsData({
    required String url,
  }) async {
    final String fileUrl =
        Uri.decodeFull(Path.basename(url)).replaceAll(RegExp(r'(\?alt).*'), '');

    return FirebaseStorage.instance.ref().child(fileUrl).getData();
  }

  @override
  Future<void> deleteFile({
    required String url,
  }) {
    final String fileUrl =
        Uri.decodeFull(Path.basename(url)).replaceAll(RegExp(r'(\?alt).*'), '');

    return FirebaseStorage.instance.ref().child(fileUrl).delete();
  }

  // TODO: Refactor the following methods to specific service classes

  @override
  void updateWeight(String uid, num value) {
    _addDocument(
      document: {
        'weight': value,
        'time': Timestamp.now(),
      },
      collection: ApiPaths.weights(uid),
    );
  }

  @override
  Stream<List<Weight>> getWeights(String uid) => _getCollectionStream(
        path: ApiPaths.weights(uid),
        fromMap: Weight.fromMap,
        sortField: 'time',
        descending: true,
      );

  @override
  Stream<List<Weight>> getWeightsThisMonth(String uid) {
    return FirebaseFirestore.instance
        .collection(ApiPaths.weights(uid))
        // TODO: Where statement to get every weight from beggining of month till today
        //.where('time', isGreaterThanOrEqualTo: DateTime.now().)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Weight.fromMap(doc.data())).toList());
  }

  @override
  void updateDailyCalorieConsumption(String uid, num value) =>
      _updateDocumentField('users/$uid', 'dailyCalories', value);

  @override
  void updateDailyProteinConsumption(String uid, num value) =>
      _updateDocumentField('users/$uid', 'dailyProteins', value);

  @override
  void updateDailyCarbsConsumption(String uid, num value) =>
      _updateDocumentField('users/$uid', 'dailyCarbs', value);

  @override
  void updateDailyFatConsumption(String uid, num value) =>
      _updateDocumentField('users/$uid', 'dailyFat', value);

  @override
  void updateProfilePicturePath(String uid, String url) =>
      _updateDocumentField('users/$uid', 'profilePicture', url);

  @override
  Stream<List<Ingredient>?> getIngredients(String uid) =>
      _getCollectionStream<Ingredient>(
          path: ApiPaths.ingredients(uid), fromMap: Ingredient.fromMap);

  @override
  Future<void> addIngredient(Ingredient ingredient, String uid) =>
      _addDocument(document: {
        'name': ingredient.name,
        'unit': ingredient.unit,
        'caloriesPerUnit': ingredient.caloriesPerUnit,
        'proteinsPerUnit': ingredient.proteinsPerUnit,
        'carbsPerUnit': ingredient.carbsPerUnit,
        'fatPerUnit': ingredient.fatPerUnit,
        'saturatedFatPerUnit': ingredient.saturatedFatPerUnit,
        'saltPerUnit': ingredient.saltPerUnit,
        'sugarPerUnit': ingredient.sugarsPerUnit,
      }, collection: ApiPaths.ingredients(uid));

  @override
  Future<String> uploadImage(File image, String path) async {
    Reference ref = FirebaseStorage.instance.ref().child(path);

    await ref.putFile(image);
    return ref.getDownloadURL();
  }

  @override
  Future<String> uploadFileAsBytes(Uint8List bytes, String path) async {
    Reference ref = FirebaseStorage.instance.ref().child(path);

    await ref.putData(bytes);
    return ref.getDownloadURL();
  }

  Future<Uint8List?> getImageData(String url) async {
    final String fileUrl =
        Uri.decodeFull(Path.basename(url)).replaceAll(RegExp(r'(\?alt).*'), '');

    return FirebaseStorage.instance.ref().child(fileUrl).getData();
  }

  @override
  Future<void> deleteImage(String url) async {
    final String fileUrl =
        Uri.decodeFull(Path.basename(url)).replaceAll(RegExp(r'(\?alt).*'), '');

    return await FirebaseStorage.instance.ref().child(fileUrl).delete();
  }

  /// Returns a stream of a collection for the given path
  ///
  /// [path] path to the collection
  /// [fromMap] a function that converts a document in the collection to a model
  /// [sortField] optional. If present the collection will be sorted by this field
  /// [descending] if [sortField] is present, this determines the sort order
  ///              (ascending or descending). False by default
  Stream<List<T>> _getCollectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic>) fromMap,
    String? sortField,
    bool descending = false,
  }) {
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

  /// Returns a stream of an object of type T, based on a document stored
  /// in the firestore
  ///
  /// [path] path to the document
  /// [fromMap] a function that converts the document to an object of type T
  Stream<T?> _getDocumentStream<T>(
      String path, T Function(Map<String, dynamic>) fromMap) {
    return FirebaseFirestore.instance
        .doc(path)
        .snapshots()
        .map((snapshot) => snapshot.data())
        .map((document) => document != null ? fromMap(document) : null);
  }

  Future<void> _deleteCollection(String path) {
    return FirebaseFirestore.instance.collection(path).get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }

  /// Adds a document to the firestore
  ///
  /// [document] the document to be added
  /// [collection] a path to the collection the document should be added to
  /// [docId] if given, the document will get this id. If no, a random id will
  /// be given
  Future<void> _addDocument({
    required Map<String, dynamic> document,
    required String collection,
    String? docId,
  }) {
    return FirebaseFirestore.instance
        .collection(collection)
        .doc(docId)
        .set(document)
        .catchError((error) => print("Failed to add document: $error"));
  }

  /// Updates the field of a document
  ///
  /// [path] the path to the document that should be updated
  /// [field] the field in the specified document that shoud be updated
  /// [value] the value that should be replaced in the field
  Future<void> _updateDocumentField(String path, String field, dynamic value) {
    return FirebaseFirestore.instance.doc(path).update(<String, dynamic>{
      field: value,
    });
  }

  /// Deletes a document
  ///
  /// [path] the path to the document to be deleted
  Future<void> _deleteDocument(String path) {
    return FirebaseFirestore.instance.doc(path).delete();
  }
}
