import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:mario/app/constant/app_colors.dart';
import 'package:mario/app/constant/constants.dart';

class WarningView extends GetView {
  final Function reload;
  const WarningView({Key? key, required this.reload}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgLogin,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/welcome.png"),
            // Row(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            // children: [
            // Text(
            // 'Loading',
            // style: GoogleFonts.montserrat(
            // textStyle:
            // const TextStyle(color: Colors.white, fontSize: 12)),
            // ),
            // LoadingAnimationWidget.prograssiveDots(
            // color: Colors.white, size: 30),
            // ],
            // )
            Container(
                height: 80,
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(baseColor),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: const BorderSide(color: baseColor)))),
                  child: const Text('Refresh'),
                  onPressed: () {
                    reload();
                  },
                )),
          ],
        )));
  }
}
