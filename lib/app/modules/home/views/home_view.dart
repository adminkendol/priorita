import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mario/app/constant/app_colors.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => WillPopScope(
        onWillPop: () async {
          if (!controller.isError.value) {
            if (await controller.conWeb2!.canGoBack()) {
              controller.conWeb2!.goBack();
              return false;
            }
            return true;
          } else {
            Navigator.pop(context);
            SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
            return true;
          }
        },
        child: Scaffold(
            resizeToAvoidBottomInset: Platform.isAndroid ? true : false,
            backgroundColor: bgLogin,
            body: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: controller.isError.value
                      ? const Image(
                          image: AssetImage('assets/images/error.png'),
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                          alignment: Alignment.center,
                        )
                      : Container(
                          margin: EdgeInsets.only(
                              top: !controller.isError.value ? 30 : 0),
                          child: controller.webWidget_2()),
                ),
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
