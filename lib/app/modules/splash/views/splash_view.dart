import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mario/app/constant/app_colors.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        backgroundColor: bgLogin,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              width: 225,
              height: 225,
            ),
            if (controller.isLoading.value)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Loading',
                    style: GoogleFonts.montserrat(
                        textStyle:
                            const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                  LoadingAnimationWidget.prograssiveDots(
                      color: Colors.white, size: 30),
                ],
              )
          ],
        ))));
  }
}
