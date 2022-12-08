import 'dart:io';
import 'dart:typed_data';

import 'package:stattrack/models/consumed_meal.dart';
import 'package:stattrack/models/ingredient.dart';
import 'package:stattrack/models/weight.dart';
import 'package:stattrack/repository/firestore_repository.dart';

import '../models/meal.dart';

abstract class Repository {
  /// Returns a stream a document containing objects of type T
  ///
  /// [path] to the document
  /// [fromMap] a function that converts the document to and object
  Stream<T?> getDocumentStream<T>({
    required String path,
    required T Function(Map<String, dynamic>) fromMap,
  });

  /// Adds a document to a collection
  ///
  /// [path] to the collection where the document should be added
  /// [document] the document to be saved
  /// [docId] the id of the document. If not given an auto generated id is set
  /// for the document
  Future<void> addDocument<T>({
    required String path,
    required Map<String, dynamic> document,
    String? docId,
  });

  /// Updates a document
  ///
  /// [path] the path to the document to update
  /// [document] the new version of the document to update the old on with
  Future<void> updateDocument({
    required String path,
    required Map<String, dynamic> document,
  });

  /// Updates a filed in a document
  ///
  /// [path] to the document to update
  /// [field] the field of the document to updated
  /// [value] the value to replace the old value
  Future<void> updateDocumentField({
    required String path,
    required String field,
    required dynamic value,
  });

  /// Deletes a document
  ///
  /// [path] to the document to delete
  Future<void> deleteDocument({
    required String path,
  });

  /// Returns a stream of a collection containing objects of type T
  ///
  /// [path] to the collection
  /// [fromMap] a function that converts the documents in the collection
  /// to objects of type T
  Stream<List<T>> getCollectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic>) fromMap,
  });

  /// Returns a stream of a collection containing objects of type T
  /// only where the objects match the predicate
  ///
  /// [path] to the collection
  /// [fromMap] a function that converts the documents in the collection
  /// to objects of type T
  /// [predicates] a list of all predicates the objects has to match
  Stream<List<T>> getCollectionStreamWhereGreaterThan<T>({
    required String path,
    required T Function(Map<String, dynamic>) fromMap,
    required String field,
    required dynamic value,
  });

  /// Returns a stream of a collection containing objects of type T
  /// where the objects in the collection are ordered by the field provided
  ///
  /// [path] to the collection
  /// [fromMap] a function converting the documents in the collection
  /// to objects of type T
  /// [field] the field to order by
  /// [descending] if the collection should be ordered by descending order or
  /// not. Default value if [false]
  Stream<List<T>> getCollectionStreamOrderBy<T>({
    required String path,
    required T Function(Map<String, dynamic>) fromMap,
    required String field,
    bool descending = false,
  });

  /// Deletes a collection
  ///
  /// [path] to the collection to delete
  Future<void> deleteCollection({
    required String path,
  });

  /// Uploads a file to firestore. Returns the download string when the file
  /// is uploaded
  ///
  /// [path] to where the file should be uploaded
  /// [file] the file to be uploaded
  Future<String> uploadFile({
    required String path,
    required File file,
  });

  /// Uploades a file based on Uint8List data to the firesotre. Returns the
  /// download string when the file is uploaded
  ///
  /// [path] the where the data should be uploaded
  /// [data] the date to be uploaded
  Future<String> uploadFileFromData({
    required String path,
    required Uint8List data,
  });

  /// Returns a file as data in Uint8List format
  ///
  /// [url] the url to the data to be returned
  Future<Uint8List?> getFileAsData({
    required String url,
  });

  /// Deletes a file from the firestore.
  ///
  /// [url] the download url of the file to be deleted
  Future<void> deleteFile({
    required String url,
  });
}
