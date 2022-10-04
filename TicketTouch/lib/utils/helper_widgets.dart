import 'package:flutter/material.dart';

SizedBox distanceHeight(double height) {
  return SizedBox(
    height: height,
  );
}

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text, textAlign: TextAlign.center),
    ),
  );
}
