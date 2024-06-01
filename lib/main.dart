import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mario/app/routes/app_pages_notif.dart';
import 'package:mario/app/utils/notif.dart';
import 'package:mario/firebase_options.dart';

import 'app/routes/app_pages.dart';

@pragma('vm:entry-point')
Future<void> myBackgroundHandler(RemoteMessage message) async {
  print('MSG NOTIF 1: $message');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  return Notif().showNotification(message);
}

@pragma('vm:entry-point')
void onSelectNotification(NotificationResponse notificationResponse) async {
  print("msgNotif: ${notificationResponse.payload}");
  Get.offAllNamed(Routes.HOME, parameters: {"isNotif": '1'});
}

initialNotif() {
  requestingPermissionForIOS();

  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  Notif().flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: onSelectNotification);

  FirebaseMessaging.onMessage.listen((message) {
    print(message);
    if (message.data.isNotEmpty) Notif().showNotification(message);
  });
}

requestingPermissionForIOS() async {
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(myBackgroundHandler);

  initialNotif();

  await GetStorage.init();

  WidgetsFlutterBinding.ensureInitialized();

  final NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await Notif()
          .flutterLocalNotificationsPlugin
          .getNotificationAppLaunchDetails();

  print('payload=');
  String? payload;

  if (notificationAppLaunchDetails != null) {
    if (notificationAppLaunchDetails.notificationResponse != null) {
      try {
        payload = notificationAppLaunchDetails.notificationResponse!.payload;
        print("PAYLOAD: $payload");
      } on Exception catch (e) {
        print("PAYLOAD ERROR: $e");
      }
    }
  }

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "MM Reward",
      initialRoute: payload == null ? AppPages.initial : AppPagesNotif.initial,
      getPages: payload == null ? AppPages.routes : AppPagesNotif.routes,
    ),
  );
}
