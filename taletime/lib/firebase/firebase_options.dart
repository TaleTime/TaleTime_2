// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import "package:firebase_core/firebase_core.dart" show FirebaseOptions;
import "package:flutter/foundation.dart"
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
          "DefaultFirebaseOptions have not been configured for macos - "
          "you can reconfigure this by running the FlutterFire CLI again.",
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          "DefaultFirebaseOptions have not been configured for windows - "
          "you can reconfigure this by running the FlutterFire CLI again.",
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          "DefaultFirebaseOptions have not been configured for linux - "
          "you can reconfigure this by running the FlutterFire CLI again.",
        );
      default:
        throw UnsupportedError(
          "DefaultFirebaseOptions are not supported for this platform.",
        );
    }
  }

  static const messagingSenderId = "98775438070";
  static const projectId = "taletime-2022";
  static const storageBucket = "taletime-2022.appspot.com";

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyAM7zJTFTpNFLk_NsxOPwknGF_Q429DMzQ",
    appId: "1:98775438070:web:32d44cdaea9a96e8bc52d7",
    messagingSenderId: messagingSenderId,
    projectId: projectId,
    authDomain: "taletime-2022.firebaseapp.com",
    storageBucket: storageBucket,
    measurementId: "G-CTPY4R634F",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyB5IRt2uwcSgR5K8F4CIvsXzQc-ed81qCo",
    appId: "1:98775438070:android:128dbe7bf0a4a9b1bc52d7",
    messagingSenderId: messagingSenderId,
    projectId: projectId,
    storageBucket: storageBucket,
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyBhTulb74TrwhYNqWQzTwRvXO7GD3rzHk8",
    appId: "1:98775438070:ios:0b40b232476cc782bc52d7",
    messagingSenderId: messagingSenderId,
    projectId: projectId,
    storageBucket: storageBucket,
    iosClientId:
        "98775438070-lnmlqj396hca45lgkis592tm33ji80co.apps.googleusercontent.com",
    iosBundleId: "com.example.taletime",
  );
}
