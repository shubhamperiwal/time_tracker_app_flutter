import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';
void main() {
  test('Non empty String', () {
    final validator = NonEmptyStringValidator();

    expect(validator.isValid("test"), true);
  });

  test('Empty String', () {
    final validator = NonEmptyStringValidator();

    expect(validator.isValid(""), false);
  });

  test('Null String', () {
    final validator = NonEmptyStringValidator();

    expect(validator.isValid(null), false);
  });
}