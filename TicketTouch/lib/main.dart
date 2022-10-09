import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:rive_splash_screen/rive_splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tickettouch/screen/auth/auth_screen.dart';
import 'package:tickettouch/screen/home/menu.dart';
import 'package:tickettouch/screen/onboarding/onboarding_screen.dart';
import 'package:tickettouch/service/firebase_auth_methods.dart';
import 'package:tickettouch/theme/theme_constants.dart';

import 'firebase_options.dart';

bool _showOnBoarding = true;

Future<void> main() async {
  if (kIsWeb) {
    await FacebookAuth.i.webInitialize(
      appId: '1140027476920190',
      cookie: true,
      xfbml: true,
      version: 'v13.0',
    );
  }

  // flutter init
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // shared preferences init
  final prefs = await SharedPreferences.getInstance();
  _showOnBoarding = prefs.getBool('showOnBoarding') ?? true;

  // firebase auth
  FlutterFireUIAuth.configureProviders(<ProviderConfiguration>[
    const EmailProviderConfiguration(),
    const GoogleProviderConfiguration(
        clientId:
            '222241256146-9kcssllbm2tf1sb0nsq2lotmcvujdi5g.apps.googleusercontent.com'),
    if (Platform.isIOS) const AppleProviderConfiguration(),
    const FacebookProviderConfiguration(clientId: '1140027476920190'),
    const TwitterProviderConfiguration(
        apiKey: 'QADxqj4o2hVlMIxgBh6kANrmc',
        apiSecretKey: 'mZ7fvbEKsHJLELXSG91znmCkWtTqYj6XbWb6HGZCAyXWLGvXAj',
        redirectUri: 'twitter-login://')
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

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemStatusBarContrastEnforced: false,
        systemNavigationBarContrastEnforced: false,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
      ),
      child: MultiProvider(
        providers: [
          Provider<FirebaseAuthMethods>(
            create: (_) => FirebaseAuthMethods(auth),
          ),
          StreamProvider(
            create: (context) => context.read<FirebaseAuthMethods>().authState,
            initialData: null,
          ),
        ],
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
            next: (context) {
              final user = context.watch<User?>();
              if (user == null && _showOnBoarding && !kIsWeb) {
                return const OnBoardingScreen();
              } else if (user == null && !_showOnBoarding) {
                return const AuthScreen();
              } else {
                return const Menu();
              }
            },
            until: () => Future.delayed(const Duration(milliseconds: 0)),
          ),
        ),
      ),
    );
  }
}
