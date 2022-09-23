import 'package:flutter/material.dart';
import 'package:tickettouch/auth.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenSate();
}

class _LogInScreenSate extends State<LogInScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const Auth();
        }));
      },
    );
  }
}
