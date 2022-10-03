import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:tickettouch/screen/auth/auth.dart';
import 'package:tickettouch/screen/home/home_screen.dart';
import 'package:tickettouch/screen/home/settings_screen.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List<ScreenHiddenDrawer> _pages = [];

  @override
  void initState() {
    super.initState();

    _pages = [
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Home',
          colorLineSelected: Colors.white,
          baseStyle: const TextStyle(color: Colors.white),
          selectedStyle:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const HomeScreen(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Account',
          colorLineSelected: Colors.white,
          baseStyle: const TextStyle(color: Colors.white),
          selectedStyle:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const ProfileScreen(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Settings',
          colorLineSelected: Colors.white,
          baseStyle: const TextStyle(color: Colors.white),
          selectedStyle:
          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SettingsScreen(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Logout',
          colorLineSelected: Colors.white,
          baseStyle: const TextStyle(color: Colors.white),
          selectedStyle:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          onTap: () async {
            await FirebaseAuth.instance.signOut();
            await Future.delayed(const Duration(milliseconds: 1500)).then((value) =>
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AuthScreen())));
          },
        ),
        Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Text('Logging out...'),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: CircularProgressIndicator(
                    color: Color(0xFF00a9ce),
                    backgroundColor: Color(0xFFb3e5f0),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: const Color(0xFF00a9ce),
      screens: _pages,
      initPositionSelected: 0,
    );
  }
}
