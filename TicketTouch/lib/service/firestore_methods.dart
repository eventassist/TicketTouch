import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tickettouch/service/storage_methods.dart';

class FirestoreMethods {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // create User in DB
  static Future createUser(
      String uid,
      String email,
      String username,
      String firstname,
      String lastname,
      Timestamp birthday,
      String mobile,
      String photoUrl) async {
    try {
      await _firestore.collection("users").doc(uid).set({
        'uid': uid,
        'email': email,
        'username': username,
        'firstname': firstname,
        'lastname': lastname,
        'birthday': birthday,
        'mobile': mobile,
        'photoUrl': photoUrl,
        'accountCreated': Timestamp.now(),
      });
    } catch (e) {
      print(e);
    }
  }

  static Future deleteUserByUid(String uid) async {
    String value = "error";
    try {
      await _firestore.collection("users").doc(uid).delete();
      value = "success";
    } catch (e) {
      print(e);
    }
    return value;
  }
}
