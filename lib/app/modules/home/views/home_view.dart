import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mario/app/constant/app_colors.dart';
import 'package:mario/app/widgets/warning_view.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => WillPopScope(
        // onWillPop: () async {
        // if (!controller.isError.value) {
        // if (await controller.conWeb2!.canGoBack()) {
        // controller.conWeb2!.goBack();
        // return false;
        // }
        // return true;
        // } else {
        // Navigator.pop(context);
        // SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
        // return true;
        // }
        // },
        onWillPop: controller.onWillPop,
        child: Scaffold(
            resizeToAvoidBottomInset: Platform.isAndroid ? true : false,
            backgroundColor: bgLogin,
            body: Stack(
              children: [
                // if (controller.isStarted.value)
                Align(
                    alignment: Alignment.center,
                    child: Container(
                        margin: EdgeInsets.only(
                            top: !controller.isError.value ? 30 : 0),
                        child: controller.webWidget_2())),
                if (controller.isError.value)
                  Align(
                      alignment: Alignment.center,
                      child: WarningView(reload: () {
                        if (controller.isConnected.value) {
                          if (controller.isError.value) {
                            controller.isError.value = false;
                            // Get.offAllNamed(Routes.HOME);
                            controller.conWeb2!.goBack();
                          }
                        }
                      })),
                if (controller.isLoading.value)
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          controller.status.value,
                          style: GoogleFonts.montserrat(
                              textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold)),
                        ),
                        LoadingAnimationWidget.prograssiveDots(
                            color: Colors.black, size: 50),
                      ],
                    ),
                  )
              ],
            ))));
  }
}
