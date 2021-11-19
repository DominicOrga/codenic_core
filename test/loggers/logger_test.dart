import 'package:codenic_core/codenic_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart' as logs;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'logger_test.mocks.dart';

@GenerateMocks([logs.Logger, FirebaseCrashlytics])
void main() {
  late FirebaseCrashlytics mockFirebaseCrashlytics;
  late logs.Logger mockLogger;

  late Logger logger;

  setUp(
    () {
      mockFirebaseCrashlytics = MockFirebaseCrashlytics();
      mockLogger = MockLogger();
      logger = Logger(
        firebaseCrashlytics: mockFirebaseCrashlytics,
        logger: mockLogger,
      );
    },
  );

  test(
    'Log message',
    () {
      // Assign
      const message = MessageLog(message: 'Test message');

      // Act
      logger.info(message);

      // Assert
      verify(mockLogger.i('Test message')).called(1);
    },
  );

  test(
    'Log message with details',
    () {
      // Assign
      const message =
          MessageLog(message: 'Test message', details: 'Test details');

      // Act
      logger.info(message);

      // Assert
      verify(mockLogger.i('Test message – Test details')).called(1);
    },
  );

  test(
    'Log message with data',
    () {
      // Assign
      const message =
          MessageLog(message: 'Test message', details: 'Test details');
      const data = {'foo': 1};

      // Act
      logger.info(message, data: data);

      // Assert
      verify(mockLogger.i('Test message – Test details {foo: 1}')).called(1);
    },
  );

  test(
    'Send error message to Crashlytics',
    () {
      // Assign
      const message =
          MessageLog(message: 'Test message', details: 'Test details');
      const data = {'foo': 1};

      final exception = Exception();
      final stackTrace = StackTrace.fromString('Sample stack trace');

      // Act
      logger.error(
        message,
        data: data,
        error: exception,
        stackTrace: stackTrace,
      );

      // Assert
      verify(mockFirebaseCrashlytics.recordError(
        exception,
        stackTrace,
        reason: 'Test message – Test details {foo: 1}',
      )).called(1);
    },
  );

  test('Failing test', () {
    expect(0, 1);
  });
}
