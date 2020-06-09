import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User {
  User({@required this.uid});
  final String uid;
}

abstract class AuthBase{
  Future<User> currentUser();
  Future<User> signInAnonymously();
  Future<void> signOut();
  Stream<User> get onAuthStateChanged;
  Future<User> signInWithGoogle();
}

class Auth implements AuthBase{

  final _firebaseAuth = FirebaseAuth.instance;
  
  // Convert firebaseuser object to user object
  User _userFromFirebase(FirebaseUser user){
    if(user == null){
      return null;
    }
    return User(uid: user.uid);
    
  }

  // declare a new getter variable in auth class
  @override
  Stream<User> get onAuthStateChanged {
    // map is a method of stream class which transforms each element of stream into a new element
    return _firebaseAuth.onAuthStateChanged.map((firebaseUser) => _userFromFirebase(firebaseUser));
  }

  @override
  Future<User> currentUser() async {
    final user = await _firebaseAuth.currentUser();
    return _userFromFirebase(user);
  }

  @override
  Future<User> signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if(googleAccount != null){
      final googleAuth = await googleAccount.authentication;
      if(googleAuth.accessToken != null && googleAuth.idToken != null){
        final authResult = await _firebaseAuth.signInWithCredential(
        GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken
        ),
      );
        return _userFromFirebase(authResult.user);
      } else{
        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google auth Token'
        );
      }
      
    } else{
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  @override
  Future<void> signOut() async{
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}