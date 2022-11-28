import 'package:cloud_firestore/cloud_firestore.dart';

class Weight {
  final num value;
  final Timestamp time;

  Weight({required this.value, required this.time});

  /// Converts a document object from firestore to a weight object
  ///
  /// [document] the document object retrieved from firestores
  static Weight fromMap(Map<String, dynamic> document) {
    return Weight(
      value: document['weight'],
      time: document['time'],
    );
  }

  // Convert firebase timestamp to datetime
  DateTime convertTimestamp(Timestamp timestamp) {
    return DateTime.fromMicrosecondsSinceEpoch(
        timestamp.microsecondsSinceEpoch);
  }

  @override
  String toString() {
    return 'Weight{value: $value, time: $time}';
  }
}
