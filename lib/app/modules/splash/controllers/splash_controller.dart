import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mario/app/routes/app_pages.dart';
import 'package:mario/app/widgets/warning_dialog.dart';

class SplashController extends GetxController {
  //TODO: Implement SplashController
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    initConnectivity();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> initConnectivity() async {
    isLoading.value = true;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      lanjut();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      lanjut();
    } else if (connectivityResult == ConnectivityResult.ethernet) {
      lanjut();
    } else {
      showDialog(
          barrierColor: Colors.black26,
          context: Get.context!,
          builder: (context) {
            return WarningDialog(
                title: "Informasi",
                description: "Tidak ada koneksi internet",
                labelA: "Restart",
                labelB: "Exit",
                actA: () {
                  Navigator.pop(context);
                  initConnectivity();
                },
                actB: () {
                  Navigator.pop(context);
                  SystemChannels.platform
                      .invokeMethod<void>('SystemNavigator.pop');
                });
          });
    }
  }

  lanjut() {
    Future.delayed(const Duration(seconds: 3), () {
      isLoading.value = false;
      Get.offAllNamed(Routes.HOME);
    });
  }
}
