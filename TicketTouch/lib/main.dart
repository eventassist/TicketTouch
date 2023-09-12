import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'
    hide PhoneAuthProvider, EmailAuthProvider;
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_ui_oauth_apple/firebase_ui_oauth_apple.dart';
import 'package:firebase_ui_oauth_facebook/firebase_ui_oauth_facebook.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:firebase_ui_oauth_twitter/firebase_ui_oauth_twitter.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:rive_splash_screen/rive_splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tickettouch/screen/auth/auth_screen.dart';
import 'package:tickettouch/screen/drawer_menu.dart';
import 'package:tickettouch/service/firebase_auth_methods.dart';
import 'package:tickettouch/theme/theme_constants.dart';

bool _showOnBoarding = true;

void main() async {
  // flutter init
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // shared preferences init
  final prefs = await SharedPreferences.getInstance();
  _showOnBoarding = prefs.getBool('showOnBoarding') ?? true;

  // firebase auth
  if (kIsWeb) {
    await FacebookAuth.i.webAndDesktopInitialize(
      appId: '1140027476920190',
      cookie: true,
      xfbml: true,
      version: 'v13.0',
    );
  }
  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    PhoneAuthProvider(),
    GoogleProvider(
        clientId:
            '222241256146-9kcssllbm2tf1sb0nsq2lotmcvujdi5g.apps.googleusercontent.com'),
    AppleProvider(),
    FacebookProvider(clientId: '1140027476920190'),
    TwitterProvider(
      apiKey: 'QADxqj4o2hVlMIxgBh6kANrmc',
      apiSecretKey: 'mZ7fvbEKsHJLELXSG91znmCkWtTqYj6XbWb6HGZCAyXWLGvXAj',
      redirectUri: 'twitter-login://',
    ),
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
}

class TicketTouchApp extends StatelessWidget {
  const TicketTouchApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;

    setSystemUiOverlayStyle();

    return MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(auth),
        ),
      ],
      child: MaterialApp(
        title: 'TicketTouch',
        //useInheritedMediaQuery: true,
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
          next: (context) {
            if (auth.currentUser == null) {
              return const AuthScreen();
            }
            return const DrawerMenu();

            /*final user = context.watch<User?>();
              if (user == null && _showOnBoarding && !kIsWeb) {
                return const OnBoardingScreen();
              } else if (user == null && !_showOnBoarding) {
                return const AuthScreen();
              } else {
                FirestoreMethods firestoreMethods = FirestoreMethods();
                if (!firestoreMethods.userDataExist(auth.currentUser)) {
                  return const SetAccountInfoScreen();
                }
                return const DrawerMenu();
              }

               */
          },
          until: () => Future.delayed(const Duration(milliseconds: 0)),
        ),
      ),
    );
  }
}
