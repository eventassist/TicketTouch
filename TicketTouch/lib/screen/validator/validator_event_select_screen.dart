import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/controllers/simple_hidden_drawer_controller.dart';

class ValidatorEventSelectScreen extends StatefulWidget {
  const ValidatorEventSelectScreen({Key? key}) : super(key: key);

  @override
  State<ValidatorEventSelectScreen> createState() =>
      _ValidatorEventSelectScreenState();
}

class _ValidatorEventSelectScreenState
    extends State<ValidatorEventSelectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 24,
          icon: const Icon(Icons.menu),
          onPressed: () => SimpleHiddenDrawerController.of(context).open(),
        ),
      ),
    );
  }
}
