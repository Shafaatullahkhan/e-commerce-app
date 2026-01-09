import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart';

import 'package:http/http.dart' as http;
import 'package:pizzashop/Admin/all_Orders.dart';
import 'package:pizzashop/main.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  initFCM() async {
    final permission = await _firebaseMessaging.requestPermission();
    print("Permission: ${permission.authorizationStatus}");
    if (permission.authorizationStatus == AuthorizationStatus.denied) {
      throw Exception("Notification Permission Denied");
    }

    final FCMToken = await _firebaseMessaging.getToken();
    print("FCM Token: $FCMToken");
    //Listen These Notifications there are three types of Listeners
    //1. When the app is in Foreground
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Message: ${message.notification!.title}");
    });

    //  2. When the app is in Background but opened and user taps on the notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? androidNotification = message.notification?.android;
      if (notification != null && androidNotification != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                'high_importance_channel',
                'High Importance Notifications',
                channelDescription:
                    'This channel is used for important notifications.',
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
    );
    awaitCreateLocalNotificationChannel();
  }

  Future<void> awaitCreateLocalNotificationChannel() async {
    const AndroidNotificationChannel androidNotificationChannel =
        AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);
  }

  Future<AccessCredentials> _getAccessToken() async {
    final ServiceAccountPath = dotenv.env['PATH_TO_SECRET'];
    String ServiceAccountJson =
        await rootBundle.loadString(ServiceAccountPath!);
    final ServiceAccount =
        ServiceAccountCredentials.fromJson(ServiceAccountJson);
    final scopes = ["https://www.googleapis.com/auth/firebase.messaging"];

    final client = await clientViaServiceAccount(ServiceAccount, scopes);
    return client.credentials;
  }

  Future<bool> sendPushNotification({
    required String deviceToken,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    if (deviceToken.isEmpty) {
      return false;
    }
    final credentials = await _getAccessToken();
    final accessToken = credentials.accessToken.data;
    final projectId = dotenv.env["PROJECT_ID"];

    await Future.delayed(Duration(seconds: 2));
    final url = Uri.parse(
        "https://fcm.googleapis.com/v1/projects/$projectId/messages:send");
    final message = {
      "message": {
        "token": deviceToken,
        "notification": {
          "title": title,
          "body": body,
        },
        "data": data ?? {},
      }
    };
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(message),
    );
    if (response.statusCode == 200) {
      print("Push Notification Sent Successfully");
      return true;
    } else {
      print("Failed to send Push Notification");
      print("Response Body: ${response.body}");
      return false;
    }
  }
}

// Handling notification responses
onDidReceiveNotificationResponse(NotificationResponse details) {
  print("Details :$details");
   navigatorKey.currentState?.push(
    MaterialPageRoute(builder: (_) => AllOrders()),
  );
  //After That you can
//Handle Navigation Based on notification data
}

onDidReceiveBackgroundNotificationResponse(NotificationResponse details) {
  print("Details :$details");
  navigatorKey.currentState?.push(
    MaterialPageRoute(builder: (_) => AllOrders()),
  );
  //After That you can
//Handle Navigation Based on notification data
}
