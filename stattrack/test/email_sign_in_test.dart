import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stattrack/pages/auth_pages/email_sign_in_page.dart';
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

  testWidgets('Email Sign In page', (WidgetTester tester) async {
    await pumpEmailSignInForm(tester);
    final emailTextFormField =
        find.byKey(const Key('emailSignInEmailTextFormField'));
    expect(emailTextFormField, findsOneWidget);

    final passwordTextFormField =
        find.byKey(const Key('emailSignInPasswordTextFormField'));
    expect(passwordTextFormField, findsOneWidget);

    var authButton = find.byKey(const Key('emailSignInFormButton'));
    expect(authButton, findsOneWidget);
  });
}
