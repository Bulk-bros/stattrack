import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stattrack/pages/email_sign_in_page.dart';
import 'package:stattrack/services/auth.dart';

class MockAuth extends Mock implements AuthBase {}

void main() {
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
          home: EmailSignInPage(
            auth: mockAuth,
            showSignUp: false,
          ),
        ),
      ),
    );
  }

  testWidgets('Email SignIn page', (WidgetTester tester) async {
    await pumpEmailSignInForm(tester);

    const email = 'user@stattrack.com';
    const password = 'Passw0rd!';

    final emailTextField = find.byKey(const Key('EmailSignInEmailField'));
    expect(emailTextField, findsOneWidget);
    await tester.enterText(emailTextField, email);

    final passwordTextField = find.byKey(const Key('EmailSignInPasswordField'));
    expect(passwordTextField, findsOneWidget);
    await tester.enterText(passwordTextField, password);

    await tester.pump();

    var authButton = find.byKey(const Key('EmailSignInButton'));
    expect(authButton, findsOneWidget);
    await tester.tap(authButton);
    await tester.pumpAndSettle();

    verify(mockAuth.signInWithEmailAndPassword(email, password)).called(1);
  });
}
