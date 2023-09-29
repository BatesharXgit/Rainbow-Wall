import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:luca/main.dart';
import 'package:luca/pages/util/notify/notify.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();

    final fCMToken = await _firebaseMessaging.getToken();

    print('Token: $fCMToken');

    initPushNotifications();
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    Get.to(NotificationsPage());
    // navigatorKey.currentState
    //     ?.pushNamed('/notification_screen', arguments: message);
  }

  Future initPushNotifications() async {
    FirebaseMessaging.instance.getInitialMessage().then((handleMessage));

    FirebaseMessaging.onMessageOpenedApp.listen((handleMessage));
  }
}
