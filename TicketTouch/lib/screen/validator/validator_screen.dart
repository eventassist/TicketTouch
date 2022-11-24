import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:tickettouch/screen/validator/dashboard_screen.dart';
import 'package:tickettouch/screen/validator/guest_list_screen.dart';
import 'package:tickettouch/screen/validator/scanner_screen.dart';
import 'package:tickettouch/service/firebase_auth_methods.dart';
import 'package:tickettouch/theme/theme_constants.dart';

class ValidatorScreen extends StatefulWidget {
  const ValidatorScreen({Key? key}) : super(key: key);

  @override
  State<ValidatorScreen> createState() => _ValidatorScreenState();
}

class _ValidatorScreenState extends State<ValidatorScreen> {
  final auth = FirebaseAuth.instance;

  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    DashboardScreen(),
    ScannerScreen(),
    GuestListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.read<FirebaseAuthMethods>().user;

    setSystemUiOverlayStyle();

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              gap: 10,
              activeColor: Colors.white,
              iconSize: 30,
              hoverColor: Colors.grey,
              rippleColor: Colors.grey,
              color: Theme.of(context).colorScheme.onBackground,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: const Color(0xFF00a9ce),
              tabs: const [
                GButton(
                  icon: Icons.space_dashboard_outlined,
                  text: 'Dashboard',
                ),
                GButton(
                  icon: Icons.qr_code_scanner_rounded,
                  text: 'Scan',
                ),
                GButton(
                  icon: Icons.people_alt_outlined,
                  text: 'Guest List',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
