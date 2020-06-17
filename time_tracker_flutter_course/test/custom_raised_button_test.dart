// WIDGET TEST
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_flutter_course/common_widgets/custom_raised_button.dart';

void main() {
  testWidgets('inner widget, onPressed', (WidgetTester tester) async {

    var pressed = false;

    // build and render widget
    await tester.pumpWidget(
      MaterialApp(
        home: CustomRaisedButton(
          child: Text('tap me'),
          onPressed: () => pressed = true,
        ),
    ));

    // check whether there is raisedbutton inside the widget
    final button = find.byType(RaisedButton);
    
    // we expect to find exactly one match
    expect(button, findsOneWidget);
    
    // ensure FlatButton isn't there.
    expect(find.byType(FlatButton), findsNothing);
    expect(find.text('tap me'), findsOneWidget);

    // test whether onPressed is called
    // remember to use await
    await tester.tap(button);
    expect(pressed, true);
  });
}