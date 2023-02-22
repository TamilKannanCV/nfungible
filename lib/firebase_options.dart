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
    apiKey: 'AIzaSyC-BgLz2SGxQqCsXNeXCiZfIuXd64rrlNc',
    appId: '1:837502129978:web:9b568f450cfcf5c0d76203',
    messagingSenderId: '837502129978',
    projectId: 'nfungibleapp',
    authDomain: 'nfungibleapp.firebaseapp.com',
    storageBucket: 'nfungibleapp.appspot.com',
    measurementId: 'G-RY5TV263CG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC9Y0JD7WZH1UHI8y8-p7DVUeMkuP97Xsw',
    appId: '1:837502129978:android:12b914ee9d90ab8dd76203',
    messagingSenderId: '837502129978',
    projectId: 'nfungibleapp',
    storageBucket: 'nfungibleapp.appspot.com',
  );
}
