import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    } else {
      throw UnsupportedError(
          'FirebaseOptions are not configured for this platform.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyAgkpuLSELD-4O3ZeUSeAsz77DoBwZtW_w",
    authDomain: "expense-tracker-560ea.firebaseapp.com",
    projectId: "expense-tracker-560ea",
    storageBucket: "expense-tracker-560ea.firebasestorage.app",
    messagingSenderId: "522804575844",
    appId: "1:522804575844:web:998385fec43bd060f6a971",
    measurementId: "YOUR_MEASUREMENT_ID", // Optional for analytics
  );
}
