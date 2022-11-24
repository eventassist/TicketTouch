import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hidden_drawer_menu/controllers/simple_hidden_drawer_controller.dart';
import 'package:provider/provider.dart';
import 'package:tickettouch/screen/tickettouch/add_friend_screen.dart';
import 'package:tickettouch/service/firebase_auth_methods.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final Stream<QuerySnapshot> friendsStream = _firestore
        .collection('users')
        .doc(uid)
        .collection('friends')
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          iconSize: 24,
          icon: const Icon(Icons.menu),
          onPressed: () => SimpleHiddenDrawerController.of(context).open(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddFriendScreen()));
        },
        child: const Icon(Icons.add_outlined),
      ),
      body: StreamBuilder(
        stream: friendsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            physics: const BouncingScrollPhysics(),
            children:
                snapshot.data!.docs.map((DocumentSnapshot documentFriend) {
              CollectionReference users = _firestore.collection('users');
              return FutureBuilder<DocumentSnapshot>(
                future: users.doc(documentFriend.id).get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                  if (userSnapshot.hasError) {
                    return const ListTile(
                      title: Text("Something went wrong"),
                    );
                  }
                  if (userSnapshot.hasData && !userSnapshot.data!.exists) {
                    return const ListTile(
                      title: Text("User does not exist"),
                    );
                  }
                  if (userSnapshot.connectionState == ConnectionState.done) {
                    return buildFriendsListItem(
                        context, userSnapshot, documentFriend);
                  }
                  return Container();
                  //return Column(
                  //  children: [
                  //    const ListTile(
                  //      title: Text(
                  //        '...............................',
                  //        style: TextStyle(
                  //            color: Colors.grey, backgroundColor: Colors.grey),
                  //      ),
                  //      subtitle: Text(
                  //        '........................',
                  //        style: TextStyle(
                  //            color: Colors.grey, backgroundColor: Colors.grey),
                  //      ),
                  //      leading: Icon(
                  //        Icons.account_circle,
                  //        size: 63,
                  //      ),
                  //    ),
                  //  ],
                  //);
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget buildFriendsListItem(
      BuildContext context, var userSnapshot, var documentFriend) {
    final uid = context.read<FirebaseAuthMethods>().user.uid;
    Map<String, dynamic> dataFriend =
        userSnapshot.data!.data() as Map<String, dynamic>;
    Map<String, dynamic> dataFriendSettings =
        documentFriend.data() as Map<String, dynamic>;
    String uidFriend = userSnapshot.data!.id.toString();
    return Slidable(
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          // delete
          SlidableAction(
            onPressed: (context) {
              //TODO
              showDialog(
                context: context,
                builder: (context) {
                  return buildDeleteAlertDialog(
                      context, uid, uidFriend, dataFriend);
                },
              );
            },
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              dataFriendSettings['isMuted']
                  ? _firestore
                      .collection('users')
                      .doc(uid)
                      .collection('friends')
                      .doc(uidFriend)
                      .set(
                      {
                        'isMuted': false,
                      },
                    )
                  : _firestore
                      .collection('users')
                      .doc(uid)
                      .collection('friends')
                      .doc(uidFriend)
                      .set(
                      {
                        'isMuted': true,
                      },
                    );
            },
            backgroundColor: Colors.grey[700]!,
            foregroundColor: Colors.white,
            icon: Icons.volume_off,
            label: 'Mute',
          ),
          SlidableAction(
            onPressed: (context) {},
            backgroundColor: Theme.of(context).colorScheme.surface,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            icon: Icons.add_location,
            label: 'Pin',
          ),
        ],
      ),

      // The child of the Slidable is what the user sees when the
      // component is not dragged.
      child: ListTile(
        title: Text(dataFriend['firstname'] + ' ' + dataFriend['lastname']),
        subtitle: Text('@' + dataFriend['username']),
        leading: dataFriend['photoUrl'].toString().isEmpty
            ? const CircleAvatar(radius: 30.0,
          backgroundImage: AssetImage('assets/images/account_avatar.png'),
          backgroundColor: Colors.transparent,)
            : CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(dataFriend['photoUrl']),
                backgroundColor: Colors.transparent,
              ),
        trailing: dataFriendSettings['isMuted']
            ? const Icon(
                Icons.volume_off,
                size: 25,
              )
            : null,
        onTap: () {
          // TODO chat implementation
          //Navigator.of(context).push(MaterialPageRoute(
          //  builder: (context) => ChatScreen(user: userSnapshot.data as User),
          //));
        },
      ),
    );
  }

  Widget buildDeleteAlertDialog(
      BuildContext context, String uid, String uidFriend, var dataFriend) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      title: const Text('Delete this friend?'),
      content: Wrap(children: [
        RichText(
          text: TextSpan(
            style: const TextStyle(
              color: Colors.black,
            ),
            children: <TextSpan>[
              const TextSpan(text: 'This will delete'),
              TextSpan(
                  text: ' @${dataFriend['username']} ',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const TextSpan(text: 'from your friends.'),
            ],
          ),
        ),
      ]),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        TextButton(
          onPressed: () {
            _firestore
                .collection('users')
                .doc(uid)
                .collection('friends')
                .doc(uidFriend)
                .delete();
            Navigator.of(context).pop();
          },
          child: Text(
            'Delete Friend',
            style: TextStyle(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ),
      ],
    );
  }
}
