import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/home_page.dart';
import 'package:time_tracker_flutter_course/app/landing_page.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_page.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

import 'mocks.dart';
void main() {

  MockAuth mockAuth;
  StreamController<User> onAuthStateChangedController;
  

  setUp((){
    mockAuth = MockAuth();
    onAuthStateChangedController = StreamController<User>();
  });

  tearDown((){
    onAuthStateChangedController.close();
  });
  
  Future<void> pumpLandingPage(WidgetTester tester) async {
    await tester.pumpWidget(
      Provider<AuthBase>(
        create: (_) => mockAuth,
        child: MaterialApp(
          home: LandingPage(),
        ),
      ),
    );

    // so that widget is rebuilt and holds the updated values.
    await tester.pump();
  }

  // take a list of user objects and covert it to a stream. Then return when onAuthStateChanged is called
  void stubOnAuthStateChangedYields(Iterable<User> onAuthStateChanged){
    onAuthStateChangedController
      .addStream(Stream<User>.fromIterable(onAuthStateChanged));
    when(mockAuth.onAuthStateChanged)
      .thenAnswer((_){
        return onAuthStateChangedController.stream;
      });
  }

  // Show circular progress indicator if user is loading
  testWidgets('Stream waiting', (WidgetTester tester) async{
    
    // create empty stream
    stubOnAuthStateChangedYields([]);

    await pumpLandingPage(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  // if user is null, lead to sign in page.
  testWidgets('null user', (WidgetTester tester) async{
    
    // create empty stream
    stubOnAuthStateChangedYields([null]);

    await pumpLandingPage(tester);

    expect(find.byType(SignInPage), findsOneWidget);
  });

  testWidgets('non-null user', (WidgetTester tester) async{
    
    // create empty stream
    stubOnAuthStateChangedYields([User(uid: '123')]);

    await pumpLandingPage(tester);

    expect(find.byType(HomePage), findsOneWidget);
  });
}