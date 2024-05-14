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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return WillPopScope(
        onWillPop: controller.onWillPop,
        child: Obx(() => Scaffold(
            resizeToAvoidBottomInset: Platform.isAndroid ? true : false,
            backgroundColor: !controller.isError.value ? Colors.white : bgLogin,
            body: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle(
                  statusBarColor:
                      !controller.isError.value ? Colors.white : bgLogin,
                  systemNavigationBarColor:
                      !controller.isError.value ? Colors.white : bgLogin,
                  statusBarIconBrightness: !controller.isError.value
                      ? Brightness.dark
                      : Brightness.light,
                  systemNavigationBarIconBrightness: !controller.isError.value
                      ? Brightness.dark
                      : Brightness.light,
                ),
                child: RefreshIndicator(
                    onRefresh: () async {
                      Future.delayed(const Duration(seconds: 3));
                      controller.isError.value = false;
                      Platform.isAndroid
                          ? controller.conWeb2!.goBack()
                          : controller.conWeb2!.reload();
                    },
                    child: SingleChildScrollView(
                        physics: controller.isError.value
                            ? const AlwaysScrollableScrollPhysics()
                            : const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: Stack(
                              children: [
                                Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                        margin: EdgeInsets.only(
                                            top: !controller.isError.value
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    20
                                                : 0),
                                        child: controller.webWidget_2())),
                                if (controller.isLoading.value)
                                  Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                          margin:
                                              const EdgeInsets.only(top: 200),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                controller.status.value,
                                                style: GoogleFonts.montserrat(
                                                    textStyle: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                              LoadingAnimationWidget
                                                  .prograssiveDots(
                                                      color: Colors.black,
                                                      size: 50),
                                            ],
                                          ))),
                                if (controller.isError.value)
                                  Align(
                                      alignment: Alignment.center,
                                      child: InkWell(
                                        child: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                color: Colors.white70,
                                                border: Border.all(
                                                  color: Colors.white,
                                                ),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(20))),
                                            child: const Icon(
                                                Icons.refresh_sharp)),
                                        onTap: () {
                                          // if (controller.isConnected.value) {
                                          if (controller.isError.value) {
                                            controller.isError.value = false;
                                            Platform.isAndroid
                                                ? controller.conWeb2!.goBack()
                                                : controller.conWeb2!.reload();
                                          }
                                          // }
                                        },
                                      )),
                              ],
                            ))))))));
  }
}
