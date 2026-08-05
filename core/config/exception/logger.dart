import 'dart:developer';
import 'package:flutter/foundation.dart';

void debugLog(dynamic data) {
  if (kDebugMode) {
    log('💡💡[LOG]💡💡 $data');
  }
}

class MessageException implements Exception {
  MessageException({required this.message});
  final String message;

  @override
  String toString() => message;
}

extension ExceptionExtension on String? {
  MessageException get toException {
    return MessageException(
      message: this ?? 'An error occurred',
    );
  }
}
