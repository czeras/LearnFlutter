// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCLwuVzzZIgaIHu04pEavsgAFZnZTk-tbc',
    appId: '1:149926752982:android:9d7be4fd7397755023cf77',
    messagingSenderId: '149926752982',
    projectId: 'yaychat',
    storageBucket: 'yaychat.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBRUS2CjDBc6VotI9o9Ux1g3IJTkCEojms',
    appId: '1:149926752982:ios:e10216da84d06aec23cf77',
    messagingSenderId: '149926752982',
    projectId: 'yaychat',
    storageBucket: 'yaychat.appspot.com',
    androidClientId: '149926752982-7f9nmjut8lifgjo3ev5tk5496ar3lhbh.apps.googleusercontent.com',
    iosClientId: '149926752982-dhul5n0ia0pear9vjuigmg3q6c1eefp6.apps.googleusercontent.com',
    iosBundleId: 'chat.yay.app',
  );
}