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
    apiKey: 'AIzaSyCDZaNfzt3u0s3blP4-9YkrOhcAbEGoUxk',
    appId: '1:694909536498:web:d50482f2c782a97f84286b',
    messagingSenderId: '694909536498',
    projectId: 'priorita-d982c',
    authDomain: 'priorita-d982c.firebaseapp.com',
    storageBucket: 'priorita-d982c.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBpTodjJmxWmy3RFlrBOXvzLp1pSTvsTZg',
    appId: '1:694909536498:android:52aa3732251b5bf184286b',
    messagingSenderId: '694909536498',
    projectId: 'priorita-d982c',
    storageBucket: 'priorita-d982c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCOUgVRKs2EfICGz0NC03YqAxTOiKR8GHM',
    appId: '1:694909536498:ios:29870f58ff8bfcad84286b',
    messagingSenderId: '694909536498',
    projectId: 'priorita-d982c',
    storageBucket: 'priorita-d982c.appspot.com',
    iosBundleId: 'id.mariominardi.app',
  );
  
}
