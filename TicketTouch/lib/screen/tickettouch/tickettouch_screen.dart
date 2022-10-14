import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:tickettouch/screen/tickettouch/chats_screen.dart';
import 'package:tickettouch/screen/tickettouch/events_screen.dart';
import 'package:tickettouch/screen/tickettouch/home_screen.dart';
import 'package:tickettouch/screen/tickettouch/tickets_screen.dart';
import 'package:tickettouch/service/firebase_auth_methods.dart';
import 'package:tickettouch/theme/theme_constants.dart';

class TicketTouchScreen extends StatefulWidget {
  const TicketTouchScreen({Key? key}) : super(key: key);

  @override
  State<TicketTouchScreen> createState() => _TicketTouchScreenState();
}

class _TicketTouchScreenState extends State<TicketTouchScreen> {
  final auth = FirebaseAuth.instance;

  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    EventsScreen(),
    TicketsScreen(),
    ChatsScreen(),
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
                  icon: Icons.house_siding,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.event_note_outlined,
                  text: 'Events',
                ),
                GButton(
                  icon: Icons.qr_code,
                  text: 'Tickets',
                ),
                GButton(
                  icon: Icons.mark_unread_chat_alt_outlined,
                  text: 'Chat',
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
