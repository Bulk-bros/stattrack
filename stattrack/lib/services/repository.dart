import 'package:stattrack/models/user.dart';

abstract class Repository {
  Stream<User?> getUsers(String uid);
}
