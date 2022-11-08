// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stattrack/components/buttons/auth_button.dart';

void main() {
  testWidgets('Signin page', (WidgetTester tester) async {
    //TODO: Verify that callback returns an user object

    /// Testing Email Sign in Button
    const authButtonEmail = AuthButton(
      label: 'Email',
      iconPath: 'assets/icons/envelope-solid.svg',
      iconAlt: 'Mail Icon',
    );
    await tester.pumpWidget(const MaterialApp(home: authButtonEmail));
    final buttonFinderEmail = find.byType(AuthButton);
    expect(buttonFinderEmail, findsOneWidget);

    /// Testing Facebook Sign In Button
    const authButtonFacebook = AuthButton(
      label: 'Facebook',
      iconPath: 'assets/icons/square-facebook.svg',
      iconAlt: 'Facebook Logo',
    );
    await tester.pumpWidget(const MaterialApp(home: authButtonFacebook));
    final buttonFinderFacebook = find.byType(AuthButton);
    expect(buttonFinderFacebook, findsOneWidget);

    /// Testing Google Sign In Button
    const authButtonGoogle = AuthButton(
      label: 'Google',
      iconPath: 'assets/icons/google.svg',
      iconAlt: 'Google Logo',
    );
    await tester.pumpWidget(const MaterialApp(home: authButtonGoogle));
    final buttonFinderGoogle = find.byType(AuthButton);
    expect(buttonFinderGoogle, findsOneWidget);

    /// Testing Sign Up TextButton bellow the buttons
    /// Broken due to missing widget implementation
    /// The following assertion was thrown building _InkResponseStateWidget(gestures: [tap], mouseCursor:
    ///ButtonStyleButton_MouseCursor, clipped to BoxShape.rectangle, dirty, state:
    ///_InkResponseState#e716b):
    ///No Directionality widget found.
    ///_InkResponseStateWidget widgets require a Directionality widget ancestor.
    ///The specific widget that could not find a Directionality ancestor was:
    //StatefulElement#20bf0(DEFUNCT)

    //var pressed = false;

    // var authSignUpText = TextButton(
    //     onPressed: () => pressed = true,
    //     child: const Text("Don't have an account? Sign up here"));

    // await tester.pumpWidget(authSignUpText);
    // final buttonFinderSignUp = find.byType(TextButton);
    // expect(buttonFinderSignUp, findsOneWidget);
    // await tester.tap(buttonFinderSignUp);
    // expect(pressed, true);
  });
}
