import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:food_corner/screens/consumer/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:food_corner/services/firebase_api.dart';

class PushNotificationHandler {
  final firebaseMessage = FirebaseMessaging();
  final FirebaseApi _firebaseApi = FirebaseApi();
  final context;

  PushNotificationHandler({this.context});

  static Future<dynamic> backgroundMessageHandler(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      final dynamic data = message['data'];
      print(data);
    }

    if (message.containsKey('notification')) {
      print('Notification Message');
      final dynamic notification = message['notification'];
      print(notification);
    }
  }

  pushNotificationConfigure() async {
    try {
      firebaseMessage.configure(
        onMessage: (msg) async {
          print('onMessage: $msg');
          return;
        },
        onResume: (msg) async {
          print('onResume: $msg');
          await Navigator.pushNamed(context, OrderScreen.id);
          return;
        },
        onLaunch: (msg) async {
          print('onLaunch: $msg');
          await Navigator.pushNamed(context, OrderScreen.id);
          return;
        },
        onBackgroundMessage: backgroundMessageHandler,
      );
      firebaseMessage.getToken().then((token) {
        _firebaseApi.updateDeviceToken(token);
      });
    } catch (err) {
      print('firebaseMessagingError: $err');
    }
  }
}
