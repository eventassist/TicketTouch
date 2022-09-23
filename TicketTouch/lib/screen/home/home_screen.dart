import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tickettouch/screen/account/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenSate();
}

class _HomeScreenSate extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            const Text('You\'re logged in!'),
            TextButton(
                onPressed: () async {
                  await auth.signOut().then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const LogInScreen();
                  }))
                  );
                },
                child: const Text('Sign out')),
          ],
        ),
      ),
    );
  }
}
