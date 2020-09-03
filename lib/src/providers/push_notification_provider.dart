import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
    
    _firebaseMessaging.configure(
      onBackgroundMessage: onBackgroundMessage,
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
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

  sendNotifications(String body, String title, String ruta, String token) async {
    final String serverToken =
        'AAAAqvASkdk:APA91bGgEt74q3T-vK152YcQBiutI60ZkH0yAmH6Hjt3IkX41bEMj4MCFo_TutrP02zyYcJGeC_yXLdGW1Uu3nmZEKMGHYSmHFJYCfvWEF9R6r1mfiF8NANMuyhKbRbh5DtnGEOOHXCv';
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

    await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': title,
            'sound': 'default',
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'ruta': ruta,
          },
          'to': token,
        },
      ),
    );
  }

  Future<String>getTokenDevice()async{
   return await _firebaseMessaging.getToken();
  }
}
