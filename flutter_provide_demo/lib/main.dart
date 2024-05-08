import 'dart:io' as io;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'firebase_options.dart';
import 'root_page/root_page.dart';
import 'utils/log/r_logs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (io.Platform.isAndroid) {
    const SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  FlutterError.onError = (FlutterErrorDetails details) {
    String log =
        "Flutter error:  \n exception:${details.exception.toString()}  \n Stack:\n${details.stack.toString()} \n ";
    RLog.e(log);
  };
  // await GlobalConfig.instance.init();
  // await CacheUtil.init();
  // UrlConfig.init();
  // JR.init();
  runApp(const RootPage());
}
