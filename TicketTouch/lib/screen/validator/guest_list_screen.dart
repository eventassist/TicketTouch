import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hidden_drawer_menu/controllers/simple_hidden_drawer_controller.dart';

class GuestListScreen extends StatefulWidget {
  const GuestListScreen({Key? key}) : super(key: key);

  @override
  State<GuestListScreen> createState() => _GuestListScreenState();
}

class _GuestListScreenState extends State<GuestListScreen> {
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
      body: ListView(
        children: [
          Slidable(
            // Specify a key if the Slidable is dismissible.
            key: const ValueKey(0),

            // The start action pane is the one at the left or the top side.
            startActionPane: ActionPane(
              // A motion is a widget used to control how the pane animates.
              motion: const DrawerMotion(),

              // A pane can dismiss the Slidable.
              dismissible: DismissiblePane(onDismissed: () {
                //TODO: Firestore delete user from event or check in user
              }),

              // All actions are defined in the children parameter.
              children: [
                // A SlidableAction can have an icon and/or a label.
                SlidableAction(
                  onPressed: checkIn,
                  backgroundColor: const Color(0xFFFE4A49),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),

            // The end action pane is the one at the right or the bottom side.
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  // An action can be bigger than the others.
                  onPressed: checkIn,
                  backgroundColor: const Color(0xFF7BC043),
                  foregroundColor: Colors.white,
                  icon: Icons.archive,
                  label: 'Check In',
                ),
              ],
            ),

            // The child of the Slidable is what the user sees when the
            // component is not dragged.
            child: const ListTile(title: Text('Christian Kimmes')),
          ),
        ],
      ),
    );
  }

  void delete(BuildContext context) {}
  void checkIn(BuildContext context) {}
}
