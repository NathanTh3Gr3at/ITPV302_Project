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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBtxKIbo1neXmHnoeftG5MhhIkbgjwGSks',
    appId: '1:48825661031:web:66053ae2dd0bf13a4506c2',
    messagingSenderId: '48825661031',
    projectId: 'thymetocook-8d0f3',
    authDomain: 'thymetocook-8d0f3.firebaseapp.com',
    storageBucket: 'thymetocook-8d0f3.appspot.com',
    measurementId: 'G-89FCD9L89X',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB_krbF6Xh5ibuOnCMh6jY9sbxkwS6S2M0',
    appId: '1:48825661031:android:039b113d792be1374506c2',
    messagingSenderId: '48825661031',
    projectId: 'thymetocook-8d0f3',
    storageBucket: 'thymetocook-8d0f3.appspot.com',
  );
}