import 'package:flutter/foundation.dart';

class Logger {
  static void log(String message) {
    // Implement logging logic here
    // print will be replaced with a proper logging framework in production
    if (kDebugMode) {
      print(message);
    }
  }
}
