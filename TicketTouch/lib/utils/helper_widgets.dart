import 'package:flutter/material.dart';

SizedBox distanceHeight(double height) {
  return SizedBox(
    height: height,
  );
}

SizedBox distanceWidth(double width) {
  return SizedBox(
    width: width,
  );
}

CircleAvatar defaultAvatar() {
  return const CircleAvatar(
    radius: 60,
    backgroundImage:AssetImage('assets/images/account_avatar.png'),
    backgroundColor: Colors.transparent,
  );
}
CircleAvatar networkAvatar(String link) {
 return CircleAvatar(
   radius: 60,
   backgroundImage: NetworkImage(link),
   backgroundColor: Colors.transparent,
 );
}

void showSnackBar(BuildContext context, String text, bool error) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: error ? const Color(0xFFB00000) : null,
      content: Text(text, textAlign: TextAlign.center),
    ),
  );
}
