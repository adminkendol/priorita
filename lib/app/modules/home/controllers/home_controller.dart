import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
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

  DateTime? currentBackPressTime;

  RxBool isStarted = false.obs;
  RxBool isConnected = false.obs;

  @override
  void onInit() {
    FocusManager.instance.primaryFocus?.unfocus();
    checkInternet();
    super.onInit();
  }

  Future<void> checkInternet() async {
    await execute(InternetConnectionChecker());

    // Create customized instance which can be registered via dependency injection
    final InternetConnectionChecker customInstance =
        InternetConnectionChecker.createInstance(
      checkTimeout: const Duration(seconds: 1),
      checkInterval: const Duration(seconds: 1),
    );

    // Check internet connection with created instance
    await execute(customInstance);
    if (!isError.value) {
      requestPermission();
      initialWeb_2();
      isStarted.value = true;
    }
  }

  void requestPermission() async {
    // await [Permission.location, Permission.camera, Permission.storage]
    await [Permission.camera, Permission.storage].request().then((value) async {
      if (Platform.isAndroid) {
        await Geolocator.checkPermission();
        await Geolocator.requestPermission();
        await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
      }
      initialNotif();
    });
  }

  initialNotif() async {
    if (await FlutterAppBadger.isAppBadgeSupported()) {
      FlutterAppBadger.updateBadgeCount(0);
    }
    if (Platform.isIOS) {
      requestingPermissionForIOS();
    }

    if (Platform.isAndroid) {
      try {
        await requestNotificationPermissions();
        var initializationSettingsAndroid =
            const AndroidInitializationSettings('@mipmap/ic_launcher');

        final InitializationSettings initializationSettings =
            InitializationSettings(
          android: initializationSettingsAndroid,
        );

        Notif().flutterLocalNotificationsPlugin.initialize(
              initializationSettings,
            );
      } catch (e) {
        initialNotif();
      }
    }

    FirebaseMessaging.onMessage.listen((message) {
      print('MSG NOTIF 2: $message');
      if (message.data.isNotEmpty) Notif().showNotification(message);
    });

    getTokenz();
  }

  Future<void> requestNotificationPermissions() async {
    final PermissionStatus status = await Permission.notification.request();
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  requestingPermissionForIOS() async {
    FirebaseMessaging.instance.requestPermission();
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

  initialWeb_2() async {
    isError.value = false;
    status.value = 'Please wait';
    settings = InAppWebViewSettings(
      disableDefaultErrorPage: true,
      javaScriptEnabled: true,
      allowFileAccessFromFileURLs: true,
      allowUniversalAccessFromFileURLs: true,
      supportMultipleWindows: true,
      geolocationEnabled: true,
      resourceCustomSchemes: ["mycustomscheme"],
      // safeBrowsingEnabled: true,
      // useOnLoadResource: false
    );
  }

  Widget webWidget_2() {
    return InAppWebView(
      initialSettings: settings,
      initialUrlRequest: URLRequest(
        url: WebUri(webUrl),
      ),
      onWebViewCreated: (controller) async {
        conWeb2 = controller;
        // if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
          // await controller.startSafeBrowsing();
        // }
      },
      onLoadStop: (controller, url) async {
        isLoading.value = false;
        urlNow.value = url.toString();
        print("urlNow ${urlNow.value}");
        if (url ==
            WebUri(
                "file:///android_asset/flutter_assets/assets/html/error.html")) {
          isError.value = true;
        } else {
          isError.value = false;
          var noHp = await controller.evaluateJavascript(
              source: "window.document.getElementById('tIdUserMember').value");
          var cookies = await controller.evaluateJavascript(
              source: "window.document.getElementById('tKeyCookie').value");
          if (!isUpdateTokenFcm.value) {
            if (noHp != null && cookies != null) {
              updateToken(noHp, cookies);
            }
          }
        }
      },
      onLoadStart: (controller, url) async {
        if (url ==
            WebUri(
                "file:///android_asset/flutter_assets/assets/html/error.html")) {
          isError.value = true;
        } else {
          isError.value = false;
        }
        // isError.value = false;
        isLoading.value = true;
        urlNow.value = url.toString();
      },
      onProgressChanged: (controller, progress) {
        progress < 100 ? isLoading.value = true : isLoading.value = false;
      },
      onReceivedError: (controller, request, error) async {
        if (Platform.isAndroid) {
          controller.loadFile(assetFilePath: "assets/html/error.html");
        }
        isLoading.value = false;
        isError.value = true;
        print("isError 1 ${isError.value}");
      },
      // onReceivedHttpError: (controller, request, errorResponse) {
      // if (Platform.isAndroid) {
      // controller.loadFile(assetFilePath: "assets/html/error.html");
      // }
      // isLoading.value = false;
      // isError.value = true;
      // print("isError 2 ${isError.value}");
      // },
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
    if (token != null && noHp.isNotEmpty) {
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

  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      if (await conWeb2!.canGoBack()) {
        conWeb2!.goBack();
        return Future.value(false);
      } else {
        InfoSnack().exitInfo('Untuk keluar, tekan back sekali lagi');
        return Future.value(false);
      }
    }
    return Future.value(true);
  }

  Future<void> execute(
    InternetConnectionChecker internetConnectionChecker,
  ) async {
    // Simple check to see if we have Internet
    // ignore: avoid_print
    print('''The statement 'this machine is connected to the Internet' is: ''');
    isConnected.value = await InternetConnectionChecker().hasConnection;
    // ignore: avoid_print
    print(
      isConnected.value.toString(),
    );

    // returns a bool

    // We can also get an enum instead of a bool
    // ignore: avoid_print
    print(
      'Current status: ${await InternetConnectionChecker().connectionStatus}',
    );
    // Prints either InternetConnectionStatus.connected
    // or InternetConnectionStatus.disconnected

    // actively listen for status updates
    final StreamSubscription<InternetConnectionStatus> listener =
        InternetConnectionChecker().onStatusChange.listen(
      (InternetConnectionStatus status) {
        switch (status) {
          case InternetConnectionStatus.connected:
            // ignore: avoid_print
            print('Data connection is available.');
            print("isStarted 1 ${isStarted.value}");
            isConnected.value = true;
            // isError.value = false;
            break;
          case InternetConnectionStatus.disconnected:
            // ignore: avoid_print
            print('You are disconnected from the internet.');
            print("isStarted 2 ${isStarted.value}");
            isError.value = true;
            isConnected.value = false;
            // if (Platform.isIOS) {
            // isStarted.value
            // ? conWeb2!.reload()
            // : Get.offAllNamed(Routes.HOME);
            // }
            break;
        }
      },
    );

    // close listener after 30 seconds, so the program doesn't run forever
    await Future<void>.delayed(const Duration(seconds: 30));
    await listener.cancel();
  }
}
