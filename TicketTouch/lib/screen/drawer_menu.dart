import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:tickettouch/screen/auth/account_screen.dart';
import 'package:tickettouch/screen/auth/set_account_details_screen.dart';
import 'package:tickettouch/screen/settings_screen.dart';
import 'package:tickettouch/screen/tickettouch/tickettouch_screen.dart';
import 'package:tickettouch/screen/validator/validator_event_select_screen.dart';
import 'package:tickettouch/screen/validator/validator_screen.dart';
import 'package:tickettouch/service/firebase_auth_methods.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  List<ScreenHiddenDrawer> _pages = [];

  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    _pages = [
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'TicketTouch',
          colorLineSelected: Colors.white,
          baseStyle: const TextStyle(color: Colors.white),
          selectedStyle:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const TicketTouchScreen(),
      ),
      if (!kIsWeb)
        ScreenHiddenDrawer(
          ItemHiddenMenu(
            name: 'Ticket Validator',
            colorLineSelected: Colors.white,
            baseStyle: const TextStyle(color: Colors.white),
            selectedStyle: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const ValidatorEventSelectScreen(),
        ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Profile',
          colorLineSelected: Colors.white,
          baseStyle: const TextStyle(color: Colors.white),
          selectedStyle:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const AccountScreen(),
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
            FirebaseAuthMethods(_auth).signOut(context);
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
    var userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);

    userDoc.get().then(
          (doc) => {
            if (!doc.exists)
              {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SetAccountDetailsScreen(),
                    )),
              },
          },
        );
    return HiddenDrawerMenu(
      backgroundColorMenu: const Color(0xFF00a9ce),
      screens: _pages,
      backgroundColorAppBar: Theme.of(context).backgroundColor,
      elevationAppBar: 0,
      disableAppBarDefault: true,
      withAutoTittleName: false,
      withShadow: false,
      slidePercent: 45,
      initPositionSelected: 0,
    );
  }
}
