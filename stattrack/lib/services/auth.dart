import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthBase {
  Stream<User?> authStateChange();
  User? get currentUser;
  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<User?> authStateChange() => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
