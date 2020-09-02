import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationProvider {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  final _mensajesController = StreamController<String>.broadcast();
  Stream<String> get mensajeStream => _mensajesController.stream;

  static Future<dynamic> onBackgroundMessage(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  initNotifications() {
    _firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.getToken().then((token) {
      print(token);
      //eF_Doz6sij8:APA91bGx-X0CQKLw2NMbW_nRZ-O-9z-doszMZjooV7uP-w_5cPKnw7M1b8GzuIumzIQqL0pQhkI0NAs81UD0VSJ16u_aGsDc6wLSacQm2fSuo_qQnNG7nkipaSOPC2nZlR5AqbTPkmPK
    });
    _firebaseMessaging.configure(
      onBackgroundMessage: onBackgroundMessage,
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        _mensajesController.sink.add(message['data']['ruta']);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        _mensajesController.sink.add(message['data']['ruta']);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        _mensajesController.sink.add(message['data']['ruta']);
      },
    );
  }

  dispose() {
    _mensajesController?.close();
  }
}
