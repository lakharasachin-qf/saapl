import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';

class MyTheme {
  static Map<int, Color> color = {
    50: Color.fromRGBO(136, 14, 79, .1),
    100: Color.fromRGBO(136, 14, 79, .2),
    200: Color.fromRGBO(136, 14, 79, .3),
    300: Color.fromRGBO(136, 14, 79, .4),
    400: Color.fromRGBO(136, 14, 79, .5),
    500: Color.fromRGBO(136, 14, 79, .6),
    600: Color.fromRGBO(136, 14, 79, .7),
    700: Color.fromRGBO(136, 14, 79, .8),
    800: Color.fromRGBO(136, 14, 79, .9),
    900: Color.fromRGBO(136, 14, 79, 1),
  };

  static ThemeData lightTheme(BuildContext context) => ThemeData(
      primarySwatch: MaterialColor(0xff8b0934, color),
      primaryColor: primaryColor,
      fontFamily: "proxi",
      cardColor: Colors.white,
      canvasColor: primaryColor,
      appBarTheme: const AppBarTheme(
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
            color: Colors.black, fontSize: 22, fontWeight: FontWeight.w600),
      ),
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white.withOpacity(0.0))
  );

  static ThemeData darkTheme(BuildContext context) => ThemeData(
      brightness: Brightness.dark,
      fontFamily: GoogleFonts.poppins().fontFamily,
      cardColor: Colors.black,
      canvasColor: secondaryColor,
      appBarTheme: const AppBarTheme(
        color: Colors.black,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
      ));
}

//Colors
const Color primaryColor = Color(0xff8b0934);
const Color secondaryColor = Color(0xfffaa921);
const Color darkBluishColor = Color(0xff403b58);
const Color whiteBackground = Color(0xFFF0F0F0);
const Color shadowColor = Color(0xE8F3F3F3);
const Color shadowDarkColor = Color(0xE8A4A4A4);
const Color lightBluishColor = Vx.indigo500;
const Color strokeSecondaryColor = Color(0xFFFCEDD0);

double getWidth(BuildContext context) => MediaQuery.of(context).size.width;

double getHeight(BuildContext context) =>
    (MediaQuery.of(context).size.height / 2) + 100;
