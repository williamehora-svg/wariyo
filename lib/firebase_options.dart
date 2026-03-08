import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        return android;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAXssDsreJfbW8xJ7hN1uxlcPGRWkKG_LM',
    authDomain: 'wariyo-billops-b5e13.firebaseapp.com',
    projectId: 'wariyo-billops-b5e13',
    storageBucket: 'wariyo-billops-b5e13.firebasestorage.app',
    messagingSenderId: '324917769851',
    appId: '1:324917769851:web:248fd0d7956417fdcdd4de',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAXssDsreJfbW8xJ7hN1uxlcPGRWkKG_LM',
    authDomain: 'wariyo-billops-b5e13.firebaseapp.com',
    projectId: 'wariyo-billops-b5e13',
    storageBucket: 'wariyo-billops-b5e13.firebasestorage.app',
    messagingSenderId: '324917769851',
    appId: '1:324917769851:web:248fd0d7956417fdcdd4de',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAXssDsreJfbW8xJ7hN1uxlcPGRWkKG_LM',
    authDomain: 'wariyo-billops-b5e13.firebaseapp.com',
    projectId: 'wariyo-billops-b5e13',
    storageBucket: 'wariyo-billops-b5e13.firebasestorage.app',
    messagingSenderId: '324917769851',
    appId: '1:324917769851:web:248fd0d7956417fdcdd4de',
  );
}
