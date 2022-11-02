import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthBase {
  /// Returns a stream that emits events when auth state changes
  Stream<User?> authStateChange();

  /// Returns the currently logged in user
  User? get currentUser;

  /// Signs in using the google auth API
  Future<User?> signInWithGoogle();

  /// Signs in using email and password
  ///
  /// [email] the email of the user to sign in
  /// [password] the password of the user to sign in
  Future<User?> signInWithEmailAndPassword(String email, String password);

  /// Creates a new user with email and password
  ///
  /// [name] the full name of the user to create
  /// [email] the email of the user to create
  /// [password] the password of the user to create
  Future<User?> createUserWithEmailAndPassword(
      String name, String email, String password);

  /// Signs out the currently logged in user
  Future<void> signOut();
}

// TODO: For each auth method, create a user in the database if it doesn't exist
class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<User?> authStateChange() => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<User?> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final UserCredential = await _firebaseAuth
            .signInWithCredential(GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        ));
        return UserCredential.user;
      } else {
        throw FirebaseAuthException(
          code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
          message: 'Missing Google ID Token',
        );
      }
    } else {
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USEr',
        message: 'Sign in aborted by user',
      );
    }
  }

  @override
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithCredential(
      EmailAuthProvider.credential(email: email, password: password),
    );
    return userCredential.user;
  }

  // TODO: Store name of user
  @override
  Future<User?> createUserWithEmailAndPassword(
      String name, String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return userCredential.user;
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
