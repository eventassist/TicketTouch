import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickettouch/service/firebase_auth_methods.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenSate();
}

class _HomeScreenSate extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    final user = context.read<FirebaseAuthMethods>().user;

    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('You\'re logged in as ${user.displayName}'),
            TextButton(
                onPressed: () async {
                  context.read<FirebaseAuthMethods>().signOut(context);
                },
                child: const Text('Sign out')),
          ],
        ),
      ),
    );
  }
}
