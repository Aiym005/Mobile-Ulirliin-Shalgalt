import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel', // тогтмол ID
    'High Importance Notifications', // суваг нэр
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print('🔔 [BG] Message ID: ${message.messageId}');
  }

  Future<void> initNotifications() async {
  NotificationSettings settings = await _messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('✅ Notification permission granted.');

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();

    await _localNotifications.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('🔘 Notification clicked with payload: ${response.payload}');
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      final android = message.notification?.android;

      if (notification != null && android != null) {
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _channel.id,
              _channel.name,
              channelDescription: _channel.description,
              importance: Importance.max,
              priority: Priority.high,
              playSound: true,
            ),
            iOS: const DarwinNotificationDetails(),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📲 Notification opened (from background): ${message.messageId}');
    });

    String? token = await _messaging.getToken(
      vapidKey: "BCcPYZe-uiNTcnsSKTM5h0lWCPJKxgh2EGp80FV3LKrM9l_f2G3_kAVxT9-kXBE7J72avaCpM4JfX_PPd4iaWKg", 
    );

    print('🔑 FCM Token: $token');
  } else {
    print('🚫 Notification permission denied.');
  }
}

}
