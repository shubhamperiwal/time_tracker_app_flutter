import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_flutter_course/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_page.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class SignInPage extends StatelessWidget {

  // onSignIn is requierd if you want to reach signinpage
  Future<void> _signInAnonymously(BuildContext context) async {
    try{
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInAnonymously();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try{
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signInWithGoogle();
    } catch (e) {
      print(e.toString());
    }
  }

  void _signInWithEmail(BuildContext context){
    // show email sign in page
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        // fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      )
    );
  }

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
			title: Text('Time Tracker'),
			elevation: 5.0, //adds a shadow
			),
			body: _buildContent(context),
			backgroundColor: Colors.grey[200],
		);
	}

  Widget _buildContent(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Sign in',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.w600,
              ),
			),
      SizedBox(height: 48.0),
			SocialSignInButton(
        assetName: 'images/google-logo.png',
        text: 'Sign in with Google',
        textColor: Colors.black87,
        color: Colors.white,
        onPressed: () => _signInWithGoogle(context),
      ),
      SizedBox(height: 8.0),
			SignInButton(
				text: 'Sign in with email',
				textColor: Colors.white,
				color: Colors.teal[700],
				onPressed: () => _signInWithEmail(context),
			),
			SizedBox(height: 8.0),
			Text(
				'or',
				style: TextStyle(
					fontSize: 14.0,
					color: Colors.black87,
				),
				textAlign: TextAlign.center,
			),
			SizedBox(height: 8.0),
			SignInButton(
				text: 'Go anonymous',
				textColor: Colors.black,
				color: Colors.lime[300],
				onPressed: () => _signInAnonymously(context),
			),
          ],
        )
	);
  }
}
