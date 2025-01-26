import 'package:logger/logger.dart';

class AppLogger {
  final logger = Logger();

  void log(Level level, String message) {
    logger.log(level, message, stackTrace: StackTrace.current);
  }
}