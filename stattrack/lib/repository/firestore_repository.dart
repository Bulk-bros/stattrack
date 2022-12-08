import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:stattrack/repository/repository.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

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
  Future<void> updateDocument({
    required String path,
    required Map<String, dynamic> document,
  }) {
    return FirebaseFirestore.instance.doc(path).update(document);
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
        Uri.decodeFull(path.basename(url)).replaceAll(RegExp(r'(\?alt).*'), '');

    return FirebaseStorage.instance.ref().child(fileUrl).getData();
  }

  @override
  Future<void> deleteFile({
    required String url,
  }) {
    final String fileUrl =
        Uri.decodeFull(path.basename(url)).replaceAll(RegExp(r'(\?alt).*'), '');

    return FirebaseStorage.instance.ref().child(fileUrl).delete();
  }
}
