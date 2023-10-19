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
    apiKey: 'AIzaSyDKry7AgGWz7Pcnto5oJD1aOVAmz6-VUx8',
    appId: '1:980105791718:android:31e1d51b1df916b940d327',
    messagingSenderId: '980105791718',
    projectId: 'community-share-v2',
    storageBucket: 'community-share-v2.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCY10QdzpVulNzR0q7c0_UdvrzZQzTOu0w',
    appId: '1:980105791718:ios:c8711549e244b03b40d327',
    messagingSenderId: '980105791718',
    projectId: 'community-share-v2',
    storageBucket: 'community-share-v2.appspot.com',
    androidClientId: '980105791718-3mmfd230lhik8grbolchftditu3ql2cl.apps.googleusercontent.com',
    iosClientId: '980105791718-hd94fuatubgf1o60ts9ppieu2ko057lm.apps.googleusercontent.com',
    iosBundleId: 'com.example.communityShare',
  );
}
