import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stattrack/pages/sign_in_page.dart';
import 'package:stattrack/services/auth.dart';

class MockAuth extends Mock implements AuthBase {}

void main() {
  ///Creates a [WidgetTester] for the given [Widget] and pumps it.
  MockAuth mockAuth = MockAuth();

  setUp(() {
    mockAuth = MockAuth();
  });

  Future<void> pumpEmailSignInForm(WidgetTester tester) async {
    var authServiceProvider = Provider<AuthBase>((ref) => mockAuth);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authServiceProvider],
        child: MaterialApp(
          home: SignInPage(
            auth: mockAuth,
          ),
        ),
      ),
    );
  }

  ///Tests the signin page widgets
  testWidgets('Signin page', (WidgetTester tester) async {
    await pumpEmailSignInForm(tester);

    final title = find.byKey(const Key('signInPageTitle'));
    expect(title, findsOneWidget);

    final loginText = find.byKey(const Key('signInPageLoginText'));
    expect(loginText, findsOneWidget);

    final facebookButton =
        find.byKey(const Key('signInPageFacebookAuthButton'));
    expect(facebookButton, findsOneWidget);

    final googleButton = find.byKey(const Key('signInPageGoogleAuthButton'));
    expect(googleButton, findsOneWidget);

    final emailButton = find.byKey(const Key('signInPageEmailAuthButton'));
    expect(emailButton, findsOneWidget);

    final signUpButton = find.byKey(const Key('signInPageSignUpButton'));
    expect(signUpButton, findsOneWidget);
  });
}
