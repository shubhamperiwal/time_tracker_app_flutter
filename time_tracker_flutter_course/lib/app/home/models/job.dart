import 'dart:ui';

import 'package:flutter/foundation.dart';

class Job {
  Job({@required this.id, @required this.name, @required this.ratePerHour});
  
  final String id;
  final String name;
  final int ratePerHour;

  factory Job.fromMap(Map<String, dynamic> data, String documentId){
    if(data == null || data['name']==null){
      return null;
    }

    final String name = data['name'];
    final int ratePerHour = data['ratePerHour'];
    return Job(
      id: documentId,
      name: name,
      ratePerHour: ratePerHour
    );
  }
  
  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'ratePerHour': ratePerHour
    };
  }

  // need to add these 2 to write model unit tests
  int get hashCode => hashValues(id, name, ratePerHour);

  bool operator==(other){
    if(identical(this, other))
      return true;
    
    // check data types
    if(runtimeType != other.runtimeType)
      return false;
    
    final Job otherJob = other;
    
    return id == otherJob.id && 
          name == otherJob.name &&
          ratePerHour == otherJob.ratePerHour;
  }

  String toString() => 'id: $id, name: $name, ratePerHour: $ratePerHour';
}