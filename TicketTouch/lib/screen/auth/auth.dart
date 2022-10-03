import 'package:flutter/material.dart';
import 'package:tickettouch/screen/auth/login_screen.dart';
import 'package:tickettouch/screen/auth/register_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  // init, show the login page
  bool showLoginScreen = true;

  void _toggleScreens() {
    setState(() {
      showLoginScreen = !showLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginScreen) {
      return LoginScreen(showRegisterScreen: _toggleScreens);
    } else {
      return RegisterScreen(showLoginScreen: _toggleScreens);
    }
  }
}