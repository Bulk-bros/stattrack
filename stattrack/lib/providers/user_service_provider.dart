import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stattrack/services/user_service.dart';

final userServiceProvider = Provider<UserService>((ref) {
  return UserService();
});
