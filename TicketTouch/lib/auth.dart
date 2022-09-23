import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:tickettouch/screen/home/hidden_drawer.dart';

class Auth extends StatelessWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemStatusBarContrastEnforced: false,
        systemNavigationBarContrastEnforced: false,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Container(
          child: auth.currentUser == null
              ? SignInScreen(
                  // no providerConfigs property - global configuration will be used instead
                  actions: [
                    AuthStateChangeAction<SignedIn>((context, state) {
                      Navigator.pushReplacementNamed(context, '/profile');
                    }),
                  ],
                )
              : ProfileScreen(
                  // no providerConfigs property here as well
                  actions: [
                    SignedOutAction((context) {
                      Navigator.pushReplacementNamed(context, '/sign-in');
                    }),
                  ],
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const HiddenDrawer();
                          }));
                        },
                        child: const Text('Home Screen')),
                  ],
                )),
    );
  }
}
