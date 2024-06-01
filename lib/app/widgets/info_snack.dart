import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mario/app/constant/app_colors.dart';

class InfoSnack {
  errorInfo(String msg) {
    Get.snackbar(
        'Error', backgroundColor: Colors.red, colorText: Colors.white, msg);
  }

  successInfo(String msg) {
    Get.snackbar(
        'Success', backgroundColor: Colors.green, colorText: Colors.white, msg);
  }

  exitInfo(String msg) {
    Get.rawSnackbar(
      backgroundColor: bgLogin,
      snackPosition: SnackPosition.BOTTOM,
      // margin: const EdgeInsets.all(30),
      messageText: Center(
        child: Text(msg,
            style: const TextStyle(fontSize: 15, color: Colors.white)),
      ),
    );
  }
}
