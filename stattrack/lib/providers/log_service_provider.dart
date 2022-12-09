import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stattrack/services/log_service.dart';

final logServiceProvider = Provider<LogService>((ref) {
  return LogService();
});
