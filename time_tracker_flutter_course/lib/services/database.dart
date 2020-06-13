import 'dart:async';
import 'package:meta/meta.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';
import 'package:time_tracker_flutter_course/services/api_path.dart';
import 'package:time_tracker_flutter_course/services/firestore_service.dart';

// Code that works on all databases (not specific to Firestore)
abstract class Database {
  Future<void> setJob(Job job);
  // Future<void> deleteJob(Job job);
  // Future<void> setEntry(Entry entry);
  // Future<void> deleteEntry(Entry entry);
  Stream<List<Job>> jobsStream();
  // Stream<List<Job>> jobsStream();
}

// using current date time to generate ID and covert it to string
String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}):
    assert(uid != null);
  final String uid;
  final _service = FirestoreService.instance;

// can create as well as update job
  Future<void> setJob(Job job) async => await _service.setData(
    path: APIPath.job(uid, job.id),
    data: job.toMap(),
  );

  Stream<List<Job>> jobsStream() => _service.collectionStream(
    path: APIPath.jobs(uid),
    builder: (data, documentId) => Job.fromMap(data, documentId),
  );  
}