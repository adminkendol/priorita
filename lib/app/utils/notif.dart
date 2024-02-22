import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mario/app/constant/app_colors.dart';

class Notif {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future showNotification(RemoteMessage message) async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    print(message.data);
    Map<String, dynamic> data = message.data;
    AndroidNotification? android = message.notification?.android;
    flutterLocalNotificationsPlugin.show(
      0,
      data['title'],
      data['note'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id_5',
          channel.name,
          icon: android?.smallIcon,
          color: bgLogin,
          // sound: const RawResourceAndroidNotificationSound('bell'),
          //sound: const UriAndroidNotificationSound("assets/tunes/bell.mp3"),
          importance: Importance.max,
          priority: Priority.high,
          enableLights: true,
          playSound: true,
          //enableLights: true,
          // other properties...
        ),
        //iOS: IOSNotificationDetails(presentAlert: true, presentSound: true),
      ),
      //payload: 'Default_Sound',
    );
  }
}
