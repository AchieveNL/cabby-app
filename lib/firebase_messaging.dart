import 'package:cabby/config/utils.dart';
import 'package:cabby/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const String channelId = 'high_importance_channel';
const String channelName = 'High Importance Notifications';
const String channelDescription =
    'This channel is used for important notifications.';

// Global Navigator Key

Future<void> setupNotification() async {
  // Request permission for notifications
  await requestNotificationPermission();

  // Initialize the plugin for local notifications
  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = const DarwinInitializationSettings();
  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      // Handle notification tap
      if (response.payload == "message") {
        navigateToScreen("/messages");
      }
    },
  );

  // Define a channel for Android
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    channelId,
    channelName,
    description: channelDescription,
    importance: Importance.max,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  setUpFirebaseMessagingListeners();
}

Future<void> requestNotificationPermission() async {
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
  );
  logger('Notification permission: ${settings.authorizationStatus}');
}

void setUpFirebaseMessagingListeners() {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage
      .listen((message) => handleFirebaseMessage(message));
  FirebaseMessaging.onMessageOpenedApp
      .listen((message) => handleFirebaseMessage(message));
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  handleFirebaseMessage(message);
}

void handleFirebaseMessage(RemoteMessage message) {
  logger("Handling Firebase message: ${message.data}, ${message.notification}");
  if (message.data['type'] == "message") {
    navigateToScreen("/messages");
  }
  showLocalNotification(message);
}

void showLocalNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(channelId, channelName,
            icon: android.smallIcon),
      ),
      payload: message.data['type'],
    );
  }
}

Future<void> onSelectNotification(String? payload) async {
  logger("Notification clicked with payload: $payload");
  if (payload != null) {
    navigateToScreen("/messages");
  }
}

void navigateToScreen(String routeName) {
  logger("Navigating to screen: $routeName ");
  if (navigatorKey.currentState == null) {
    logger("Navigator key is null");
    return;
  }
  navigatorKey.currentState?.pushReplacementNamed(routeName);
}
