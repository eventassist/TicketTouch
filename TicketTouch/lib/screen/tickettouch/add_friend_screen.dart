import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tickettouch/utils/helper_widgets.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({Key? key}) : super(key: key);

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  String userNameText = '';

  Stream<QuerySnapshot> usersSnapshot = FirebaseFirestore.instance
      .collection('users')
      // TODO not show self .where('username', isNotEqualTo: '#ownUserName')
      .orderBy('username', descending: true)
      .limit(20)
      .snapshots();

  initSearchingPost(String textEntered) {
    usersSnapshot = FirebaseFirestore.instance
        .collection('users')
        // TODO not show self .where('username', isNotEqualTo: '#ownUserName')
        .where('username', isGreaterThanOrEqualTo: textEntered)
        .orderBy('username', descending: true)
        .limit(20)
        .snapshots();

    setState(() {
      usersSnapshot;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: TextField(
        onChanged: (textEntered) {
          setState(() {
            userNameText = textEntered;
          });
          initSearchingPost(textEntered);
        },
        decoration: InputDecoration(
            hintText: "Add Friend",
            hintStyle: const TextStyle(color: Colors.grey),
            border: InputBorder.none,
            suffixIcon: IconButton(
                onPressed: () {
                  initSearchingPost(userNameText);
                },
                icon: const Icon(Icons.search))),
      )),
      body: SafeArea(
        child: StreamBuilder(
          stream: usersSnapshot,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                return ListTile(
                  onTap: () {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .collection('friends')
                        .doc(document.id)
                        .set({
                          'isMuted': false,
                        })
                        .then((value) =>
                            showSnackBar(context, "Friend added", false))
                        .catchError((error) => showSnackBar(
                            context, "Failed to add user: $error", true));
                    Navigator.pop(context);
                  },
                  title: Text('@' + data['username']),
                  subtitle: Text(data['firstname'] + ' ' + data['lastname']),
                  leading: data['photoUrl'].toString().isEmpty
                      ? const CircleAvatar(radius: 30.0,
                  backgroundImage: AssetImage('assets/images/account_avatar.png'),
                  backgroundColor: Colors.transparent,)
                      : CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(data['photoUrl']),
                          backgroundColor: Colors.transparent,
                        ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
