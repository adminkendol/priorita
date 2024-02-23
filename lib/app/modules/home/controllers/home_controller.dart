import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mario/app/constant/constants.dart';
import 'package:mario/app/data/providers/get_token_provider.dart';
import 'package:mario/app/utils/notif.dart';
import 'package:mario/app/widgets/info_snack.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  GetTokenProvider tokenProvider = Get.find<GetTokenProvider>();

  RxString fcmToken = "Getting Firebase Token".obs;
  RxBool isToken = false.obs;
  RxBool isDevice = false.obs;
  RxBool isUpdateTokenFcm = false.obs;

  RxBool isLoading = false.obs;
  RxBool isError = false.obs;
  RxString status = ''.obs;
  InAppWebViewSettings? settings;
  InAppWebViewController? conWeb2;
  RxString urlNow = ''.obs;

  @override
  void onInit() {
    initialNotif();
    initialWeb_2();
    super.onInit();
  }

  void requestPermission() async {
    await [
      Permission.location,
      Permission.camera,
      // Permission.microphone,
      Permission.storage
    ].request();
  }

  initialNotif() {
    if (Platform.isIOS) {
      requestingPermissionForIOS();
    }

    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    if (Platform.isAndroid) {
      Notif().flutterLocalNotificationsPlugin.initialize(
            initializationSettings,
          );
    }

    FirebaseMessaging.onMessage.listen((message) {
      print(message);
      if (message.data.isNotEmpty) Notif().showNotification(message);
    });

    getTokenz();
  }

  requestingPermissionForIOS() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('IOS Notif:User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('IOS Notif:User granted provisional permission');
    } else {
      print('IOS Notif:User declined or has not accepted permission');
    }

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  getTokenz() async {
    String? token = await _firebaseMessaging.getToken();
    GetStorage().write('fcm', token);
    fcmToken.value = token!;
    print("TOKEN: $fcmToken");
    isToken.value = true;
  }

  initialWeb_2() {
    status.value = 'Please wait';
    requestPermission();
    settings = InAppWebViewSettings(
      javaScriptEnabled: true,
      allowFileAccessFromFileURLs: true,
      allowUniversalAccessFromFileURLs: true,
      supportMultipleWindows: true,
      resourceCustomSchemes: ["mycustomscheme"],
    );
  }

  Widget webWidget_2() {
    return InAppWebView(
      initialSettings: settings,
      initialUrlRequest: URLRequest(
        url: WebUri(webUrl),
      ),
      onCreateWindow: (controller, createWindowAction) async {
        HeadlessInAppWebView? headlessWebView;
        headlessWebView = HeadlessInAppWebView(
          windowId: createWindowAction.windowId,
          onLoadStart: (controller, url) async {
            url.printInfo(info: "urlInfo");
            if (url != null) {
              InAppBrowser.openWithSystemBrowser(
                  url: url); // to open with the system browser
              // or use the https://pub.dev/packages/url_launcher plugin
            }
            // dispose it immediately
            await headlessWebView?.dispose();
            headlessWebView = null;
          },
        );
        headlessWebView?.run();
        // return true to tell that we are handling the new window creation action
        return true;
      },
      onLoadStop: (controller, url) async {
        isLoading.value = false;
        urlNow.value = url.toString();
        var noHp = await controller.evaluateJavascript(
            source: "window.document.getElementById('tIdUserMember').value");
        var cookies = await controller.evaluateJavascript(
            source: "window.document.getElementById('tKeyCookie').value");
        if (!isUpdateTokenFcm.value) {
          updateToken(noHp, cookies);
        }
      },
      onLoadStart: (controller, url) {
        isError.value = false;
        isLoading.value = true;
        urlNow.value = url.toString();
      },
      onProgressChanged: (controller, progress) {
        progress < 100 ? isLoading.value = true : isLoading.value = false;
      },
      onReceivedError: (controller, request, error) async {
        isLoading.value = false;
        isError.value = true;
        InfoSnack().errorInfo('Server sedang ada perbaikan');
      },
      onWebViewCreated: (InAppWebViewController con) {
        conWeb2 = con;
      },
      onPermissionRequest: (controller, request) async {
        print(request);
        return PermissionResponse(
            resources: request.resources,
            action: PermissionResponseAction.GRANT);
      },
      onGeolocationPermissionsShowPrompt:
          (InAppWebViewController controller, String origin) async {
        return GeolocationPermissionShowPromptResponse(
            origin: origin, allow: true, retain: true);
      },
    );
  }

  updateToken(String noHp, String cookies) async {
    var token = GetStorage().read('fcm');
    print("param: $noHp | $token");
    if (token != null) {
      await tokenProvider.getXtoken().then((value) async {
        await tokenProvider
            .saveToken(
                noHp: noHp,
                tokenFcm: token,
                cookies: cookies,
                xToken: value.body!.response!.token)
            .then((value) {
          isUpdateTokenFcm.value = true;
        });
      });
    }
  }
}
