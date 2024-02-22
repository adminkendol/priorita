import 'package:flutter/material.dart';

Color primaryBlue = const Color(0xff2972ff);
Color primaryLight = const Color.fromARGB(255, 230, 232, 237);
Color textBlack = const Color(0xff222222);
Color textGrey = const Color(0xff94959b);
Color textWhiteGrey = const Color(0xfff1f1f5);

TextStyle heading2 = const TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w700,
);

TextStyle heading5 = const TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
);

TextStyle heading6 = const TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
);

TextStyle regular16pt = const TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
);

const Color nearlyWhite = Color(0xFFFAFAFA);
const Color white = Color(0xFFFFFFFF);
const Color background = Color(0xFFF2F3F8);
const Color nearlyDarkBlue = Color(0xFF2633C5);

const Color nearlyBlue = Color(0xFF00B6F0);
const Color nearlyBlack = Color(0xFF213333);
const Color grey = Color(0xFF3A5160);
const Color darkGrey = Color(0xFF313A44);

const Color darkText = Color(0xFF253840);
const Color darkerText = Color(0xFF17262A);
const Color lightText = Color(0xFF4A6572);
const Color deactivatedText = Color(0xFF767676);
const Color dismissibleBackground = Color(0xFF364A54);
const Color spacer = Color(0xFFF2F2F2);
const String fontName = 'Roboto';

const primaryColor = Color(0xFF2697FF);
const primaryContainerColor = Color(0xFF2C3280);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFFf3feff);
const selectItem = Color(0xFF00B7FF);

Color bgPrimary = const Color(0xfff23486c);
const dialogColor = Color(0xFFFAFAFA);
Color textHeadColor = '#2F2723'.toColor();
const iconColor = Color(0xFF808089);

const TextTheme textTheme = TextTheme(
  headline4: display1,
  headline5: headline,
  headline6: title,
  subtitle2: subtitle,
  bodyText2: body2,
  bodyText1: body1,
  caption: caption,
);

const TextStyle display1 = TextStyle(
  fontFamily: fontName,
  fontWeight: FontWeight.bold,
  fontSize: 36,
  letterSpacing: 0.4,
  height: 0.9,
  color: darkerText,
);

const TextStyle headline = TextStyle(
  fontFamily: fontName,
  fontWeight: FontWeight.bold,
  fontSize: 24,
  letterSpacing: 0.27,
  color: darkerText,
);

const TextStyle title = TextStyle(
  fontFamily: fontName,
  fontWeight: FontWeight.bold,
  fontSize: 16,
  letterSpacing: 0.18,
  color: darkerText,
);

const TextStyle subtitle = TextStyle(
  fontFamily: fontName,
  fontWeight: FontWeight.w400,
  fontSize: 14,
  letterSpacing: -0.04,
  color: darkText,
);

const TextStyle body2 = TextStyle(
  fontFamily: fontName,
  fontWeight: FontWeight.w400,
  fontSize: 14,
  letterSpacing: 0.2,
  color: darkText,
);

const TextStyle body1 = TextStyle(
  fontFamily: fontName,
  fontWeight: FontWeight.w400,
  fontSize: 16,
  letterSpacing: -0.05,
  color: darkText,
);

const TextStyle caption = TextStyle(
  fontFamily: fontName,
  fontWeight: FontWeight.w400,
  fontSize: 12,
  letterSpacing: 0.2,
  color: lightText, // was lightText
);

extension ColorExtension on String {
  toColor() {
    var hexColor = this.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}