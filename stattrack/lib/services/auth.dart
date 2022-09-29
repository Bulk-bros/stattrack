abstract class AuthBase {}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;
}
