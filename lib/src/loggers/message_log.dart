import 'logger.dart';

/// A message container for [Logger].
class MessageLog {
  const MessageLog({required this.message, this.details});

  /// The general log message.
  final String message;

  /// Additional details about the logged activity.
  final String? details;

  MessageLog copyWith({
    String? message,
    String? details,
  }) {
    return MessageLog(
      message: message ?? this.message,
      details: details ?? this.details,
    );
  }

  /// Returned message format:
  ///
  /// ```dart
  /// MessageLog(message: 'Hello') => Hello
  ///
  /// MessageLog(message: 'Hello', details: 'world') => Hello – world
  /// ```
  @override
  String toString() => details != null ? '$message – $details' : message;
}
