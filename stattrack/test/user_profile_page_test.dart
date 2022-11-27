///Widget tests for the landing page

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stattrack/pages/user_profile_page.dart';
import 'package:stattrack/services/auth.dart';

///class MockAuth extends Mock implements AuthBase {}
///
///void main() async {
///  MockAuth mockAuth = MockAuth();
///
///  setUp(() {
///    mockAuth = MockAuth();
///    mockAuth.signInWithEmailAndPassword("user@stattrack.com", "Passw0rd!");
///    when(mockAuth.signInWithEmailAndPassword("user@stattrack.com", "Passw0rd!"))
///        .thenReturn(Future.value(mockAuth.currentUser));
///  });
///
///  Future<void> pumpUserProfilePage(WidgetTester tester) async {
///    var authServiceProvider = Provider<User?>((ref) => mockAuth.currentUser);
///    await tester.pumpWidget(
///      ProviderScope(
///        overrides: [authServiceProvider],
///        child: const MaterialApp(home: UserProfilePage()),
///      ),
///    );
///  }
///
///  testWidgets("Testing User Profile page", (WidgetTester tester) async {
///    await pumpUserProfilePage(tester);
 /// });
///}
