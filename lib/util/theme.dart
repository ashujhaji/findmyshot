import 'package:flutter/material.dart';

ThemeData lightTheme() {
  TextTheme _lightTextTheme(TextTheme base) {
    return base.copyWith(
      headline1: base.headline1.copyWith(
          inherit: true,
          fontSize: 34.0,
          color: Colors.grey[800],
          fontFamily: 'Avenir',
          height: 1.3),
      headline2: base.headline2.copyWith(
          inherit: true,
          fontSize: 28.0,
          color: Colors.grey[800],
          fontFamily: 'Avenir',
          height: 1.2),
      headline3: base.headline3.copyWith(
          inherit: true,
          fontSize: 22.0,
          color: Colors.grey[800],
          fontFamily: 'Avenir',
          height: 1.2),
      headline4: base.headline4.copyWith(
          inherit: true,
          fontSize: 20.0,
          color: AppColor.HEADING_COLOR,
          fontFamily: 'Avenir',
          height: 1.2),
      headline5: base.headline5.copyWith(
          inherit: true,
          fontSize: 17.0,
          color: AppColor.HEADING_COLOR,
          fontFamily: 'Avenir',
          fontWeight: FontWeight.values[5],
          height: 1.3),
      headline6: base.headline6.copyWith(
          inherit: true,
          fontSize: 15.0,
          color: AppColor.HEADING_COLOR,
          fontFamily: 'Avenir',
          height: 1.2),
      subtitle1: base.subtitle1.copyWith(
        inherit: true,
        fontSize: 12.0,
        color: Colors.grey[800],
        fontFamily: 'Avenir',
      ),
      subtitle2: base.subtitle2.copyWith(
        inherit: true,
        fontSize: 14.0,
        color: Colors.grey[800],
        fontFamily: 'Avenir',
      ),
      bodyText1: base.bodyText1.copyWith(
          inherit: true,
          fontSize: 13.0,
          color: AppColor.BODY_TEXT_COLOR,
          fontFamily: 'Avenir',
          height: 1.2),
      bodyText2: base.bodyText2.copyWith(
          inherit: true,
          fontSize: 10.0,
          color: AppColor.BODY_TEXT_COLOR,
          fontFamily: 'Avenir',
          height: 1.5),
    );
  }

  final ThemeData base = ThemeData.light();
  return base.copyWith(
    textTheme: _lightTextTheme(
      base.textTheme,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
    primaryColor: Colors.white,
  );
}

class AppColor {
  static const WHITE_COLOR = const Color(0xffffffff);
  static const APP_COLOR = const Color(0xff008c9d);
  static const SECONDARY_COLOR = const Color(0xffff4f5a);
  static const APP_COLOR_100 = const Color(0x1f2754F1);
  static const HEADING_COLOR = const Color(0xff161d28);
  static const BODY_TEXT_COLOR = const Color(0xff030f23);
  static const NAVY_BLUE = const Color(0xff0a1c63);
  static const DIALOG_BG = const Color(0x5f000000);
  static const GREY_300 = const Color(0xffd1d6dc);
  static const BLUE_900 = const Color(0xff01060F);
  static const BLUE_200 = const Color(0xff65AAFB);
  static const BLUE_300 = const Color(0xff25CAD1);
  static const GREY_900 = const Color(0xff161D28);
  static const PURPLE_100 = const Color(0xff7272EE);
  static const PURPLE_500 = const Color(0xff5855FF);
  static const PURPLE_600 = const Color(0xff9D55E4);
  static const PURPLE_700 = const Color(0xff550F8B);
  static const YELLOW_100 = const Color(0xffFFEEDD);
  static const YELLOW_200 = const Color(0xffF1D8BF);
  static const LIGHT_GREEN = const Color(0xffD2FFF7);
  static const BLUE_100 = const Color(0xffD2FFF7);
  static const GREEN_200 = const Color(0xff309280);
  static const GREY_50 = const Color(0xff808387);
  static const GREY_30 = const Color(0xffb3b4b7);
  static const BG_GREY = const Color(0xfff4f4f4);
  static const DARK_GREY = const Color(0xff01060F);
  static const CYAN = const Color(0xff00C9F2);

  static const ColorsArray = [0xffFF9AA2,0xffB5EAD7,0xffDEFDE0,0xffF0DEFD,0xff309280,0xff65AAFB];
}
