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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBnoxbHxiX3_HlQgXnJB7C-MImokEaLIQ8',
    appId: '1:66357301666:web:0e1e43ce08787f10d9e2fb',
    messagingSenderId: '66357301666',
    projectId: 'flutter-d-3135d',
    authDomain: 'flutter-d-3135d.firebaseapp.com',
    storageBucket: 'flutter-d-3135d.appspot.com',
    measurementId: 'G-BLFDZZXP0R',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDalsMLOLag7x5yDQ_CKhAE6Khp8ccGE78',
    appId: '1:66357301666:android:424fb585938e7c49d9e2fb',
    messagingSenderId: '66357301666',
    projectId: 'flutter-d-3135d',
    storageBucket: 'flutter-d-3135d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCHymESVjcEkLVsJgw0BDzCQqQ2Oqhw8PU',
    appId: '1:66357301666:ios:93c7c28d7e5cdd91d9e2fb',
    messagingSenderId: '66357301666',
    projectId: 'flutter-d-3135d',
    storageBucket: 'flutter-d-3135d.appspot.com',
    iosClientId: '66357301666-6v5tedi230got9t4o3klv27r54otj7bo.apps.googleusercontent.com',
    iosBundleId: 'com.example.term',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCHymESVjcEkLVsJgw0BDzCQqQ2Oqhw8PU',
    appId: '1:66357301666:ios:37dd965fe3431e05d9e2fb',
    messagingSenderId: '66357301666',
    projectId: 'flutter-d-3135d',
    storageBucket: 'flutter-d-3135d.appspot.com',
    iosClientId: '66357301666-12g9rqvi1r6gdkhkfcrobtvndcm7j2ek.apps.googleusercontent.com',
    iosBundleId: 'com.example.term.RunnerTests',
  );
}
