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
    apiKey: 'AIzaSyCGl6aeh9desSkxdaGeWRC9KjgnrYaRIYo',
    appId: '1:933885207174:web:5397b10abffb7496c22707',
    messagingSenderId: '933885207174',
    projectId: 'infopark-cab',
    authDomain: 'infopark-cab.firebaseapp.com',
    storageBucket: 'infopark-cab.appspot.com',
    measurementId: 'G-0GNSYCSCVC',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDi-jqUVyElI2DNGftuYvPJVZrRHrRW6xw',
    appId: '1:933885207174:android:89965a2f17bdd39fc22707',
    messagingSenderId: '933885207174',
    projectId: 'infopark-cab',
    storageBucket: 'infopark-cab.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAZmbmJI8OPVEprpefh9CJJs_0ctRKwyJE',
    appId: '1:933885207174:ios:1f0c677ba3f71252c22707',
    messagingSenderId: '933885207174',
    projectId: 'infopark-cab',
    storageBucket: 'infopark-cab.appspot.com',
    iosBundleId: 'com.example.infoCabu',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAZmbmJI8OPVEprpefh9CJJs_0ctRKwyJE',
    appId: '1:933885207174:ios:1f0c677ba3f71252c22707',
    messagingSenderId: '933885207174',
    projectId: 'infopark-cab',
    storageBucket: 'infopark-cab.appspot.com',
    iosBundleId: 'com.example.infoCabu',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCGl6aeh9desSkxdaGeWRC9KjgnrYaRIYo',
    appId: '1:933885207174:web:6a69d8a670ca40dfc22707',
    messagingSenderId: '933885207174',
    projectId: 'infopark-cab',
    authDomain: 'infopark-cab.firebaseapp.com',
    storageBucket: 'infopark-cab.appspot.com',
    measurementId: 'G-B2EMDX8005',
  );
}
