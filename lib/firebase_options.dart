// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCPIk2iCw8uInh-CkpmdURd9m46D4rJKXI',
    appId: '1:792356450992:web:32c39b6f2802bf4e92c175',
    messagingSenderId: '792356450992',
    projectId: 'tontiflex-f4fb5',
    authDomain: 'tontiflex-f4fb5.firebaseapp.com',
    storageBucket: 'tontiflex-f4fb5.firebasestorage.app',
    measurementId: 'G-DT4779GDKD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAQNUkf8Sbw86iIYRlMliaDOGWYHyz8a-A',
    appId: '1:792356450992:android:32e745f76dcf692b92c175',
    messagingSenderId: '792356450992',
    projectId: 'tontiflex-f4fb5',
    storageBucket: 'tontiflex-f4fb5.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyASMYUZaZU20F4jJvCnqLW8F7uTtar0pS0',
    appId: '1:792356450992:ios:56903e84395b63c992c175',
    messagingSenderId: '792356450992',
    projectId: 'tontiflex-f4fb5',
    storageBucket: 'tontiflex-f4fb5.firebasestorage.app',
    iosBundleId: 'com.example.tontiflex',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyASMYUZaZU20F4jJvCnqLW8F7uTtar0pS0',
    appId: '1:792356450992:ios:56903e84395b63c992c175',
    messagingSenderId: '792356450992',
    projectId: 'tontiflex-f4fb5',
    storageBucket: 'tontiflex-f4fb5.firebasestorage.app',
    iosBundleId: 'com.example.tontiflex',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCPIk2iCw8uInh-CkpmdURd9m46D4rJKXI',
    appId: '1:792356450992:web:d1eb6d87337edc2692c175',
    messagingSenderId: '792356450992',
    projectId: 'tontiflex-f4fb5',
    authDomain: 'tontiflex-f4fb5.firebaseapp.com',
    storageBucket: 'tontiflex-f4fb5.firebasestorage.app',
    measurementId: 'G-M0YVXEKRJZ',
  );
}
