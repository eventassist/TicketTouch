import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageMethods {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<String> uploadFile(File file) async {
    var user = _auth.currentUser;

    var storageRef = _storage.ref().child('user/profile/${user!.uid}');
    try {
      await storageRef.putFile(file);
    } on FirebaseException catch (e) {
      print(e);
    }
    String downloadUrl = await storageRef.getDownloadURL();
    return downloadUrl;
  }
}
