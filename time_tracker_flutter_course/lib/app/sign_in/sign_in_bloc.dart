import 'dart:async';

import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class SignInBloc {
  SignInBloc({@required this.auth});
  final AuthBase auth;
  final StreamController<bool> _isLoadingController = StreamController<bool>();
  Stream<bool> get isLoadingStream => _isLoadingController.stream;

// when sign in page is removed from widget tree and we dont need bloc
  void dispose(){
    _isLoadingController.close();
  }

  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  Future<User> signInAnonymously() async{
    try{
      _setIsLoading(true);
      return await auth.signInAnonymously();
    } catch(e) {
      _setIsLoading(false);
      rethrow;
    } 
  }

  Future<User> signInWithGoogle() async{
    try{
      _setIsLoading(true);
      return await auth.signInWithGoogle();
    } catch(e) {
      _setIsLoading(false);
      rethrow;
    } 
  }

}