import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';


bool get isDarkMode {
  final brightness = SchedulerBinding.instance.window.platformBrightness;
  return brightness == Brightness.dark;
}

void setSystemUiOverlayStyle() {
  if (isDarkMode) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemStatusBarContrastEnforced: false,
        systemNavigationBarContrastEnforced: false));
  } else {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        systemStatusBarContrastEnforced: false,
        systemNavigationBarContrastEnforced: false));
  }
}

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  backgroundColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    surface: Color(0xFF00a9ce),
    onSurface: Colors.white,
    primary: Color(0xFF00a9ce),
    onPrimary: Color(0xFF323232),
    secondary: Color(0xff323232),
    onSecondary: Colors.white,
    error: Color(0xFFB00000),
    onError: Colors.white,
    background: Colors.white,
    onBackground: Color(0xff323232),
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Colors.grey,
    contentTextStyle: TextStyle(color: Colors.white),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Color(0xff323232),
    elevation: 0,
  )
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  backgroundColor: const Color(0xFF323232),
  scaffoldBackgroundColor: const Color(0xFF323232),
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
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Colors.black,
    contentTextStyle: TextStyle(color: Colors.white),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF323232),
  ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff323232),
      foregroundColor: Colors.white,
      elevation: 0,
    )
);
