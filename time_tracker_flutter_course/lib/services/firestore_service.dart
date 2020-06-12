import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

// Firestore specific code
class FirestoreService {

// to make it a singleton
  FirestoreService._();
  static final instance = FirestoreService._();

  // helper method to add document to firestore
  Future<void> setData({String path, Map<String, dynamic> data}) async{
    final reference = Firestore.instance.document(path);
    print('$path: $data');
    await reference.setData(data);

  }

// helper method to read collections of docs from firestore
  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T builder(Map<String, dynamic> data ),
  }) {
    final reference = Firestore.instance.collection(path);
    final snapshots = reference.snapshots();

    return snapshots.map((collectionSnap) => 
      collectionSnap.documents.map(
        (snapshotDoc) => builder(snapshotDoc.data)).toList());

  }

}