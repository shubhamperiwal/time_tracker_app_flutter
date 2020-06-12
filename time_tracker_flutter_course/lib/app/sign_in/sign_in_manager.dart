import 'dart:async';

import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class SignInManager {
  SignInManager({@required this.auth, @required this.isLoading});
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;
  
  Future<User> signInAnonymously() async{
    try{
      isLoading.value = true;
      return await auth.signInAnonymously();
    } catch(e) {
      isLoading.value = false;
      rethrow;
    } 
  }

  Future<User> signInWithGoogle() async{
    try{
      isLoading.value = true;
      return await auth.signInWithGoogle();
    } catch(e) {
      isLoading.value = false;
      rethrow;
    } 
  }

}