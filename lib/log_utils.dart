import 'dart:developer';

import 'package:flutter/foundation.dart';

class LogUtils {
  static void printDebugLog(String tag, String msg) {
    if (kReleaseMode) {
      return;
    }
    log('$tag : $msg');
  }
}
