import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stattrack/services/auth.dart';

final authProvider = Provider<AuthBase>((ref) {
  return Auth();
});
