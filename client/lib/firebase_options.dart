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
    apiKey: 'AIzaSyA_tO_-hz7xovM4gZ4lL-DNzK_erzU9wog',
    appId: '1:780976515457:web:3ecefcfcdfacc5ec2c2080',
    messagingSenderId: '780976515457',
    projectId: 'chat-app---ai-powered',
    authDomain: 'chat-app---ai-powered.firebaseapp.com',
    storageBucket: 'chat-app---ai-powered.appspot.com',
    measurementId: 'G-23BJ3L4KDS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAw3ah5AZuF71j6qvmLOvcL3tKf65DfgUE',
    appId: '1:780976515457:android:58e5dc8c3b0c9c3f2c2080',
    messagingSenderId: '780976515457',
    projectId: 'chat-app---ai-powered',
    storageBucket: 'chat-app---ai-powered.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDBSPqXtVsiz6qyCmjLwFyzMGxuEOLW1LQ',
    appId: '1:780976515457:ios:831e8193708971e02c2080',
    messagingSenderId: '780976515457',
    projectId: 'chat-app---ai-powered',
    storageBucket: 'chat-app---ai-powered.appspot.com',
    iosClientId: '780976515457-vkd5pe84oeigh8eie498mpl7bsq4f4gr.apps.googleusercontent.com',
    iosBundleId: 'com.example.client',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDBSPqXtVsiz6qyCmjLwFyzMGxuEOLW1LQ',
    appId: '1:780976515457:ios:831e8193708971e02c2080',
    messagingSenderId: '780976515457',
    projectId: 'chat-app---ai-powered',
    storageBucket: 'chat-app---ai-powered.appspot.com',
    iosClientId: '780976515457-vkd5pe84oeigh8eie498mpl7bsq4f4gr.apps.googleusercontent.com',
    iosBundleId: 'com.example.client',
  );
}