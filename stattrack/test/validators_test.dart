import 'package:flutter_test/flutter_test.dart';
import 'package:stattrack/utils/validator.dart';

void main() {
  test('Valid Username', () {
    expect(Validator.isValidUsername('JohnDoe123'), true);
  });

  test('Too Short Username', () {
    expect(Validator.isValidUsername('JohnDoe'), false);
  });
  test('Invalid Username', () {
    expect(Validator.isValidUsername('John Doe'), false);
  });

  test('Empty Username', () {
    expect(Validator.isValidUsername(''), false);
  });

  test('Valid Email', () {
    expect(Validator.isValidEmail("flutter@google.com"), true);
  });
  test('Invalid Email', () {
    expect(Validator.isValidEmail("flutter@google"), false);
  });
  test('Valid Password', () {
    expect(Validator.isValidPassword("&1Sgjs2gfsGJ_78"), true);
  });
  test('Valid Password, No Symbols', () {
    expect(Validator.isValidPassword("1Sgjs2gfsGJ78"), false);
  });
  test('Invalid Password', () {
    expect(Validator.isValidPassword("123jfuhsd4567"), false);
  });
}
