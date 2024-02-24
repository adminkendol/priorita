import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mario/app/utils/notif.dart';
import 'package:mario/firebase_options.dart';

import 'app/routes/app_pages.dart';

@pragma('vm:entry-point')
Future<void> myBackgroundHandler(RemoteMessage message) async {
  print('MSG NOTIF 1: $message');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  return Notif().showNotification(message);
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(myBackgroundHandler);

  await GetStorage.init();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Mario Minardi Priorita",
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    ),
  );
}
