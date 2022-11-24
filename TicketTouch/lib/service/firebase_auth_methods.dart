import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:tickettouch/screen/auth/auth_screen.dart';
import 'package:tickettouch/screen/drawer_menu.dart';
import 'package:tickettouch/service/firestore_methods.dart';
import 'package:tickettouch/utils/helper_widgets.dart';
import 'package:twitter_login/twitter_login.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;

  FirebaseAuthMethods(this._auth);

  // User Getter
  User get user => _auth.currentUser!;

  // _auth.userChanges();
  // _auth.idTokenChanges();

  // Email Sign Up => in register_screen.dart TODO Email Sign Up here

  // Email Sign In => in login_screen.dart TODO Email Sign In here

  // Email verification => in register_screen.dart and login_screen.dart TODO Email verification here

  // Google
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        googleProvider.addScope('email');
        googleProvider
            .addScope('https://www.googleapis.com/auth/userinfo.email');
        googleProvider
            .addScope('https://www.googleapis.com/auth/userinfo.profile');

        UserCredential userCredential =
            await _auth.signInWithPopup(googleProvider).whenComplete(() {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DrawerMenu(),
              ));
        });
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn(
          scopes: <String>[
            'email',
            'https://www.googleapis.com/auth/userinfo.email',
            'https://www.googleapis.com/auth/userinfo.profile',
          ],
        ).signIn();

        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth?.accessToken,
            idToken: googleAuth?.idToken,
          );
          UserCredential userCredential =
              await _auth.signInWithCredential(credential).whenComplete(() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DrawerMenu(),
                    ));
              });
        }
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!, true);
    }
  }

  // Facebook
  Future<void> signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: [
          'email',
          'public_profile',
        ],
      );

      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      UserCredential userCredential =
          await _auth.signInWithCredential(facebookAuthCredential);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!, true);
    }
  }

  // Apple
  Future<void> signInWithApple(BuildContext context) async {
    try {
      // To prevent replay attacks with the credential returned from Apple, we
      // include a nonce in the credential request. When signing in with
      // Firebase, the nonce in the id token returned by Apple, is expected to
      // match the sha256 hash of `rawNonce`.
      const charset =
          '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
      final random = Random.secure();
      final rawNonce =
          List.generate(32, (_) => charset[random.nextInt(charset.length)])
              .join();
      final nonce = sha256.convert(utf8.encode(rawNonce)).toString();

      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oAuthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      UserCredential userCredential =
          await _auth.signInWithCredential(oAuthCredential);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!, true);
    }
  }

  // Twitter
  Future<void> signInWithTwitter(BuildContext context) async {
    try {
      if (kIsWeb) {
        // Create a new provider
        TwitterAuthProvider twitterProvider = TwitterAuthProvider();

        // Once signed in, return the UserCredential
        await FirebaseAuth.instance.signInWithPopup(twitterProvider);
      } else {
        // Create a TwitterLogin instance
        final twitterLogin = TwitterLogin(
          apiKey: 'QADxqj4o2hVlMIxgBh6kANrmc',
          apiSecretKey: 'mZ7fvbEKsHJLELXSG91znmCkWtTqYj6XbWb6HGZCAyXWLGvXAj',
          redirectURI: 'twitter-login://',
        );

        // Trigger the sign-in flow
        var authResult = await twitterLogin.login();

        // Create a credential from the access token
        var twitterAuthCredential = TwitterAuthProvider.credential(
          accessToken: authResult.authToken!,
          secret: authResult.authTokenSecret!,
        );

        // Once signed in, return the UserCredential
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(twitterAuthCredential);
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!, true);
    }
  }

  // Sign Out
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut().whenComplete(() {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AuthScreen(),
            ));
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!, true);
    }
  }

  // Delete Account
  Future<void> deleteAccount(BuildContext context) async {
    FirebaseAuthMethods firebaseAuthMethods = FirebaseAuthMethods(_auth);
    try {
      // Delete FirebaseAuth User
      await _auth.currentUser!.delete().whenComplete(() {
        // Delete Firestore User
        FirestoreMethods.deleteUserByUid(firebaseAuthMethods.user.uid);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AuthScreen(),
            ));
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!, true);
    }
  }
}
