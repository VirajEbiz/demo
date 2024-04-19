import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const primaryColor = Color(0xff01B768);
const secondaryColor = Color(0xffFF6060);
const textfieldBorderColor = Color(0xffC5C5C5);
const textfieldBackgroundColor = Color(0xffEEEEEE);
const textfiledHintColor = Color(0xff848484);

var themeData = ThemeData(
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      minimumSize: const MaterialStatePropertyAll(
        Size(
          double.infinity,
          50,
        ),
      ),
      backgroundColor: const MaterialStatePropertyAll(
        primaryColor,
      ),
      foregroundColor: const MaterialStatePropertyAll(
        Colors.white,
      ),
    ),
  ),
  fontFamily: GoogleFonts.lato().fontFamily,
  primaryColor: primaryColor,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: primaryColor,
    onPrimary: primaryColor,
    secondary: primaryColor,
    onSecondary: primaryColor,
    error: Colors.red,
    onError: Colors.red,
    background: Colors.white,
    onBackground: Colors.black,
    surface: Colors.white,
    onSurface: Colors.black,
  ),
);

var textFieldDecoration = InputDecoration(
  hintText: "Field Hint",
  labelText: "Field Label",
  floatingLabelBehavior: FloatingLabelBehavior.auto,
  hintStyle: const TextStyle(
      // color: textfiledHintColor,
      ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(
      color: textfieldBorderColor,
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(
      color: textfieldBorderColor,
    ),
  ),
);
