import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    surface: Color(0xFF00a9ce),
    onSurface: Colors.white,
    primary: Color(0xFF00a9ce),
    onPrimary: Colors.white,
    secondary: Color(0xff323232),
    onSecondary: Colors.white,
    error: Color(0xFFB00000),
    onError: Colors.white,
    background: Color(0xff323232),
    onBackground: Colors.white,
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Color(0xff323232),
    contentTextStyle: TextStyle(color: Colors.white),
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    surface: Color(0xFF00a9ce),
    onSurface: Colors.white,
    primary: Color(0xFF00a9ce),
    onPrimary: Colors.white,
    secondary: Color(0xff323232),
    onSecondary: Colors.white,
    error: Color(0xFFB00000),
    onError: Colors.white,
    background: Color(0xff323232),
    onBackground: Colors.white,
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.black,
    contentTextStyle: TextStyle(color: Colors.white),
  ),
);
