import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'Used for important notifications',
    importance: Importance.max,
  );

  static Future<void> initialize() async {
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    await _messaging.requestPermission(alert: true, badge: true, sound: true);

    await _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _local.initialize(settings);
    await getDeviceToken();

    FirebaseMessaging.onMessage.listen((message) {
      _showNotification(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleClick(message);
    });

    final initial = await _messaging.getInitialMessage();
    if (initial != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleClick(initial);
      });
    }
  }

  static Future<void> _showNotification(RemoteMessage message) async {
    String? title = message.data['title'] ?? message.notification?.title;
    String body = message.data['body'] ?? message.notification?.body ?? '';

    debugPrint("Showing notification - Title: $title, Body: $body");

    await _local.show(
      message.hashCode,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.max,
          priority: Priority.high,
          category: AndroidNotificationCategory.message,
        ),
      ),
      payload: message.data['screen'],
    );
  }

  static void _handleClick(RemoteMessage message) {
    if (message.data['screen'] == 'home') {
      navigatorKey.currentState?.pushNamed('/home');
    }
  }

  static Future<String?> getDeviceToken() async {
    final token = await _messaging.getToken();
    debugPrint("FCM Token: $token");
    return token;
  }
}
