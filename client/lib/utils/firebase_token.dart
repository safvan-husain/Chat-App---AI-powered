import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

// During app launch
Future<String?> getFirebaseToken() async {
  await Firebase.initializeApp();
  late String? _token;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  _token = await _firebaseMessaging.getToken();
  return _token;
}

void listenToNotifications() {
  FirebaseMessaging _fcm = FirebaseMessaging.instance;
  _fcm.requestPermission();
}
