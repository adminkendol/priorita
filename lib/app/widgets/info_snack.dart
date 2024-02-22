import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InfoSnack {
  errorInfo(String msg) {
    Get.snackbar(
        'Error', backgroundColor: Colors.red, colorText: Colors.white, msg);
  }

  successInfo(String msg) {
    Get.snackbar(
        'Success', backgroundColor: Colors.green, colorText: Colors.white, msg);
  }
}
