import 'package:flutter/foundation.dart';

void logger(dynamic message) {
  if (kDebugMode) {
    logger(message);
  }
}
