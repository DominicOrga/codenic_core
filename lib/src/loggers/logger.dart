import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:logger/logger.dart' as logs;

import 'message_log.dart';

/// A logger that sends messages to the console and Firebase Crashlytics for
/// error reports.
class Logger {
  Logger({
    required FirebaseCrashlytics firebaseCrashlytics,
    logs.Logger? logger,
  })  : _firebaseCrashlytics = firebaseCrashlytics,
        _logger = logger ?? logs.Logger(printer: logs.PrettyPrinter());

  /// An instance of [FirebaseCrashlytics].
  ///
  /// See https://pub.dev/packages/firebase_crashlytics.
  final FirebaseCrashlytics _firebaseCrashlytics;

  /// An instance of [logs.Logger].
  ///
  /// The default logger will only log events in debug mode.
  ///
  /// See https://pub.dev/packages/logger.
  final logs.Logger _logger;

  /// Sets a user identifier that will be associated with subsequent fatal and
  /// non-fatal reports in Firebase Crashlytics.
  Future<void> setUserId(String? userId) =>
      _firebaseCrashlytics.setUserIdentifier(userId ?? '');

  void debug(
    MessageLog message, {
    Map<String, dynamic>? data,
    dynamic error,
    StackTrace? stackTrace,
  }) =>
      _logger.d(_formatMessageData(message, data), error, stackTrace);

  void info(
    MessageLog message, {
    Map<String, dynamic>? data,
    dynamic error,
    StackTrace? stackTrace,
  }) =>
      _logger.i(_formatMessageData(message, data), error, stackTrace);

  void warn(
    MessageLog message, {
    Map<String, dynamic>? data,
    dynamic error,
    StackTrace? stackTrace,
  }) =>
      _logger.w(_formatMessageData(message, data), error, stackTrace);

  /// Logs an error in the debug console and submits it to
  /// [FirebaseCrashlytics].
  void error(
    MessageLog message, {
    Map<String, dynamic>? data,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    _firebaseCrashlytics.recordError(
      error,
      stackTrace,
      reason: _formatMessageData(message, data),
    );

    _logger.e(_formatMessageData(message, data), error, stackTrace);
  }

  String _formatMessageData(MessageLog message, data) =>
      data != null ? '$message $data' : '$message';
}
