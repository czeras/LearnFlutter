import 'package:flutter/foundation.dart';

class RLog {
  static const String appName = 'JoyRide';
  static const String defaultTag = 'yqdf';

  String tag;
  String? keyword;

  RLog.create(this.tag);

  // static VeAlogImpl get alog => VeAlogImpl.instance;

  static d(dynamic msg, [String? tag = appName]) {
    debugPrint('[${DateTime.now()}] $msg');
    // alog.debug(tag: tag ?? defaultTag, message: msg);
    // if (GlobalConfig.isDebug && !Platform.isIOS) debugPrint('[${DateTime.now()}] $msg');
  }

  static i(String msg, {String? tag = appName}) {
    d(msg, tag);
    // alog.info(tag: tag ?? defaultTag, message: msg);
    // if (GlobalConfig.isDebug && !Platform.isIOS) debugPrint('[${DateTime.now()}] $msg');
  }

  static w(dynamic msg, {String? tag = appName}) =>
      d(msg, tag); //alog.warn(tag: tag ?? defaultTag, message: msg);

  static e(dynamic msg, {Exception? exception, String? tag = appName}) =>
      d(msg, tag); //alog.error(tag: tag ?? defaultTag, message: msg);

  ///打印红色log
  static r(String tag, dynamic msg) =>
      d(msg, tag); //alog.error(tag: tag ?? defaultTag, message: msg);
  printLog(dynamic msg) => d(msg, tag);
  printStack() => d(StackTrace.current, tag);
}
