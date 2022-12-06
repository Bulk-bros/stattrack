import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stattrack/repository/user_service.dart';

final userServiceProvider = Provider<UserService>((ref) {
  return UserService();
});
