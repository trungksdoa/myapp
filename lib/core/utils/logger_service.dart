// lib/core/utils/logger_service.dart
import 'package:logger/logger.dart';

class LoggerService {
  static final LoggerService _instance = LoggerService._internal();

  // Logger instance
  late final Logger _logger;

  // Private constructor
  LoggerService._internal() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: false,
      ),
    );
  }

  // Factory constructor
  factory LoggerService() => _instance;

  // Static getter for instance
  static LoggerService get instance => _instance;

  // Logging methods
  void v(dynamic message) {
    _logger.v(message);
  }

  void d(dynamic message) {
    _logger.d(message);
  }

  void i(dynamic message) {
    _logger.i(message);
  }

  void w(dynamic message) {
    _logger.w(message);
  }

  void e(dynamic message) {
    _logger.e(message);
  }

  void wtf(dynamic message) {
    _logger.wtf(message);
  }

  // Direct access to logger if needed
  Logger get logger => _logger;
}
