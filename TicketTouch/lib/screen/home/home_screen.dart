import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tickettouch/screen/auth/auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenSate();
}

class _HomeScreenSate extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You\'re logged in as ${user.email!}'),
            TextButton(
                onPressed: () async {
                  await auth.signOut().then((value) => Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const AuthScreen();
                      })));
                },
                child: const Text('Sign out')),
          ],
        ),
      ),
    );
  }
}
