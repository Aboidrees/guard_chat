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
    apiKey: 'AIzaSyBE5Q6N3jTSk0wsDoz2vrFkzV4WUZWnalY',
    appId: '1:158202031849:android:954770b03c72ec1ac60a78',
    messagingSenderId: '158202031849',
    projectId: 'guard-chat-382001',
    storageBucket: 'guard-chat-382001.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD44FFuYuZSCgkSRIWy0dlmoLejvwmlYq0',
    appId: '1:158202031849:ios:2807645e3fb1a9cec60a78',
    messagingSenderId: '158202031849',
    projectId: 'guard-chat-382001',
    storageBucket: 'guard-chat-382001.appspot.com',
    androidClientId: '158202031849-h3gmntvcpng7q6fr1cvjjqkd311q6gsb.apps.googleusercontent.com',
    iosClientId: '158202031849-gbldihmc6irluqlfr6v39r4fpokvtrd1.apps.googleusercontent.com',
    iosBundleId: 'info.aboidrees.flashChat',
  );
}
