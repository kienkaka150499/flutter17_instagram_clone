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
    apiKey: 'AIzaSyC5m7-XYykXtJtKbmxDCJ5zTDuGsWG5Je4',
    appId: '1:965531179477:web:3e4fd1747baebbcb65855c',
    messagingSenderId: '965531179477',
    projectId: 'instagram-clone-26376',
    authDomain: 'instagram-clone-26376.firebaseapp.com',
    storageBucket: 'instagram-clone-26376.appspot.com',
    measurementId: 'G-JDD8NNFCT3',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB2bP5Kv6q_cFLV9eIEaswmXtz397U7w5k',
    appId: '1:965531179477:android:57b2539f0db0bd1565855c',
    messagingSenderId: '965531179477',
    projectId: 'instagram-clone-26376',
    storageBucket: 'instagram-clone-26376.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD5SviAch82FvAh0YFpO3HPfhUsMR7S9Go',
    appId: '1:965531179477:ios:304c17774de411de65855c',
    messagingSenderId: '965531179477',
    projectId: 'instagram-clone-26376',
    storageBucket: 'instagram-clone-26376.appspot.com',
    androidClientId: '965531179477-hgj7rf3nhr21qp9u6hksshlr0ev2mou9.apps.googleusercontent.com',
    iosClientId: '965531179477-f432jjnfqij66b7lbld50t1odsumgfh7.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutter17InstagramClone',
  );
}