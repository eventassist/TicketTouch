import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive_splash_screen/rive_splash_screen.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tickettouch/screen/auth/auth.dart';
import 'package:tickettouch/screen/home/menu.dart';
import 'package:tickettouch/screen/onboarding/onboarding_screen.dart';
import 'package:tickettouch/theme/theme_constants.dart';

import 'firebase_options.dart';

bool _showOnBoarding = true;

void main() async {
  // flutter init
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // shared preferences init
  final prefs = await SharedPreferences.getInstance();
  _showOnBoarding = prefs.getBool('showOnBoarding') ?? true;

  // firebase auth
  FlutterFireUIAuth.configureProviders([
    const EmailProviderConfiguration(),
    const PhoneProviderConfiguration(),
    const GoogleProviderConfiguration(
        clientId:
            '222241256146-9kcssllbm2tf1sb0nsq2lotmcvujdi5g.apps.googleusercontent.com'),
    const AppleProviderConfiguration(),
  ]);

  // firebase remote config
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval:
        const Duration(minutes: 5), // set after development to: 1 to 12 hours
  ));
  await remoteConfig.setDefaults(const {
    "example_param_1": 42,
    "example_param_2": 3.14159,
    "example_param_3": true,
    "example_param_4": "Hello, world!",
  });
  await remoteConfig.fetchAndActivate();


  // run the app and send data with
  runApp(const TicketTouchApp());
  //runApp(Auth());
}

class TicketTouchApp extends StatelessWidget {
  const TicketTouchApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemStatusBarContrastEnforced: false,
        systemNavigationBarContrastEnforced: false,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
      child: MaterialApp(
        title: 'TicketTouch',
        useInheritedMediaQuery: true,
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        // first app start = OnBoardingScreen
        // signed out = LoginInScreen
        // signed in = HiddenDrawer (HomeScreen)
        home: SplashScreen.navigate(
          backgroundColor: const Color(0xFF00a9ce),
          endAnimation: 'splash',
          name: 'assets/animations/splash_animation.riv',
          next: (context) => auth.currentUser == null
              ? (_showOnBoarding
                  ? const OnBoardingScreen()
                  : const AuthScreen())
              : const Menu(),
          until: () => Future.delayed(const Duration(milliseconds: 0)),
        ),
      ),
    );
  }
}
