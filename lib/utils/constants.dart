import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Constants {
  static const Color themeColor = Color.fromRGBO(126, 57, 251, 1);
  static const Color darkerText = Color(0xFF17262A);
  static const Color darkText = Color(0xFF253840);
  static const Color lightText = Color(0xFF4A6572);
  static const Color secondaryThemeColor = Color.fromRGBO(83, 38, 166, 1);
  static const Color background = Color.fromARGB(255, 243, 243, 249);
  static const String fontName = 'Roboto';
  static const String mainScreenRoute = '/main';
  static const String userPath = 'Colleges/PICT/Users';
  static const String doubtPath = 'Colleges/PICT/Doubts';
  static final progressIndicator = Center(
    child: SizedBox(
      height: 200,
      width: 200,
      child: Lottie.asset('assets/images/loading_lottie.json'),
    ),
  );
  static final errorLottie = Center(
      child: SizedBox(
    height: 300,
    width: 300,
    child: Lottie.asset('assets/images/error_lottie.json'),
  ));

  static BoxShadow boxShadow = BoxShadow(
      color: Constants.secondaryThemeColor.withOpacity(0.5),
      blurRadius: 20.0,
      offset: Offset(10.0, 10.0));
  static const TextStyle errorText = TextStyle(
      fontSize: 25, fontWeight: FontWeight.bold, color: Constants.darkText);

  static const TextStyle display1 = TextStyle(
    // h4 -> display1
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 36,
    letterSpacing: 0.4,
    height: 0.9,
    color: darkerText,
  );

  static const TextStyle headline = TextStyle(
    // h5 -> headline
    fontFamily: fontName,
    fontWeight: FontWeight.w700,
    fontSize: 45,
    letterSpacing: 1,

    color: Colors.white,
  );
  static const TextStyle hi = TextStyle(
      // h5 -> headline
      fontFamily: fontName,
      fontWeight: FontWeight.w700,
      fontSize: 20,
      letterSpacing: 1,
      color: darkText);

  static const TextStyle title = TextStyle(
    // h6 -> title
    fontFamily: fontName,
    fontWeight: FontWeight.bold,
    fontSize: 16,
    letterSpacing: 0.18,
    color: darkerText,
  );

  static const TextStyle subtitle = TextStyle(
    // subtitle2 -> subtitle
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,

    color: Colors.white,
  );

  static const TextStyle listTile = TextStyle(
      // body1 -> body2
      fontFamily: fontName,
      fontWeight: FontWeight.w600,
      fontSize: 18,
      color: darkText);

  static const TextStyle body1 = TextStyle(
      // body2 -> body1
      fontFamily: fontName,
      fontWeight: FontWeight.w400,
      fontSize: 16,
      color: Colors.white);

  static const TextStyle caption = TextStyle(
    // Caption -> caption
    fontFamily: fontName,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.2,
    color: lightText, // was lightText
  );
}
