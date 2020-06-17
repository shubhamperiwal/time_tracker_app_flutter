import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_form_stateful.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class MockAuth extends Mock implements AuthBase {}
void main() {

  MockAuth mockAuth;

  setUp((){
    mockAuth = MockAuth();
  });
  
  Future<void> pumpEmailSignInForm(WidgetTester tester,
  {VoidCallback onSignedIn}) async {
    await tester.pumpWidget(
      Provider<AuthBase>(
        create: (_) => mockAuth,
        child: MaterialApp(
          home: Scaffold(body: EmailSignInFormStateful(
            onSignedIn: onSignedIn,
          ))
        ),
      ),
    );
  }

  void stubSignInWithEmailAndPasswordSucceeds(){
    when(mockAuth.signInWithEmailAndPassword(any, any))
      .thenAnswer((_) => Future<User>.value(User(uid: '124')));
  }

  void stubSignInWithEmailAndPasswordThrows(){
    when(mockAuth.signInWithEmailAndPassword(any, any))
      .thenThrow(PlatformException(code: 'ERROR_WRONG_PASSWORD'));
  }

  group('sign in', () {
    // WHEN user doesn't enter email and password
    // AND user taps on the sign in button
    // THEN signInWithEmailAndPassword is not called
    testWidgets('no email/pwd', (WidgetTester tester) async {
      var signedIn = false;
      await pumpEmailSignInForm(tester, onSignedIn: () => signedIn=true);

      // simulate tapping sign in button
      final signInButton = find.text('Sign in');
      await tester.tap(signInButton);

      // verifies method in mock object was never called
      verifyNever(mockAuth.signInWithEmailAndPassword(any, any));
      expect(signedIn, false);
    });

    // WHEN user enters VALID email and password
    // AND user taps on the sign in button
    // THEN signInWithEmailAndPassword is called
    // ANd user is signed in
    testWidgets('enter email/pwd', (WidgetTester tester) async {
      var signedIn = false;
      await pumpEmailSignInForm(tester, onSignedIn: () => signedIn=true);

      // when test runs this retuns future with user
      stubSignInWithEmailAndPasswordSucceeds();

      const email = 'email@email.com';
      const password = 'password';

      // add email to email text field
      final emailField = find.byKey(Key('email'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, email);

      final passwordField = find.byKey(Key('password'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, password);

      // trigger rebuild of widget
      await tester.pump();
      // in case there are animations and you need to wait for them to settle
      // await tester.pumpAndSettle();

      // simulate tapping sign in button
      final signInButton = find.text('Sign in');
      await tester.tap(signInButton);

      // verifies method in mock object was never called
      verify(mockAuth.signInWithEmailAndPassword(email, password)).called(1);
      expect(signedIn, true);
    });

    // WHEN user enters INVALID email and password
    // AND user taps on the sign in button
    // THEN signInWithEmailAndPassword is called
    // ANd user is NOT signed in
    testWidgets('enter email/pwd', (WidgetTester tester) async {
      var signedIn = false;
      await pumpEmailSignInForm(tester, onSignedIn: () => signedIn=true);

      // when test runs this retuns future with user
      stubSignInWithEmailAndPasswordThrows();

      const email = 'email@email.com';
      const password = 'password';

      // add email to email text field
      final emailField = find.byKey(Key('email'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, email);

      final passwordField = find.byKey(Key('password'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, password);

      // trigger rebuild of widget
      await tester.pump();
      // in case there are animations and you need to wait for them to settle
      // await tester.pumpAndSettle();

      // simulate tapping sign in button
      final signInButton = find.text('Sign in');
      await tester.tap(signInButton);

      // verifies method in mock object was never called
      verify(mockAuth.signInWithEmailAndPassword(email, password)).called(1);
      expect(signedIn, false);
    });
  });



// update registration tests by using stubs as you did for sign in
  group('register', () {
    // WHEN user taps on secondary button
    // THEN form toggles to registration mode
    testWidgets('reg mode toggle', (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);

      // simulate tapping sign in button
      final secondaryButton = find.text('Need an account? Register');
      await tester.tap(secondaryButton);

      await tester.pump();
      
      final createAccountButton = find.text('Create an account');
      expect(createAccountButton, findsOneWidget);
    });

    // WHEN user taps on secondary button
    // AND user enters email and pwd
    // AND user taps on register button
    // THEN createUserWithEmailAndPassword is called
    testWidgets('createUser', (WidgetTester tester) async {
      await pumpEmailSignInForm(tester);

      // simulate tapping sign in button
      final secondaryButton = find.text('Need an account? Register');
      await tester.tap(secondaryButton);

      await tester.pump();

      const email = 'email@email.com';
      const password = 'password';

      // add email to email text field
      final emailField = find.byKey(Key('email'));
      expect(emailField, findsOneWidget);
      await tester.enterText(emailField, email);

      final passwordField = find.byKey(Key('password'));
      expect(passwordField, findsOneWidget);
      await tester.enterText(passwordField, password);

      // trigger rebuild of widget
      await tester.pump();
      
      final createAccountButton = find.text('Create an account');      
      expect(createAccountButton, findsOneWidget);
      await tester.tap(createAccountButton);

      verify(mockAuth.createUserWithEmailAndPassword(email, password));
    });
  });
}