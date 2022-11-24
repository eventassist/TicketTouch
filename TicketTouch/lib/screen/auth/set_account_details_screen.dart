import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:tickettouch/screen/drawer_menu.dart';
import 'package:tickettouch/service/firestore_methods.dart';
import 'package:intl/intl.dart';
import 'package:tickettouch/service/storage_methods.dart';
import 'package:tickettouch/utils/helper_widgets.dart';

class SetAccountDetailsScreen extends StatefulWidget {
  const SetAccountDetailsScreen({Key? key}) : super(key: key);

  @override
  State<SetAccountDetailsScreen> createState() => _SetAccountDetailsScreenState();
}

class _SetAccountDetailsScreenState extends State<SetAccountDetailsScreen> {
  final _auth = FirebaseAuth.instance;

  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _mobileController = TextEditingController();
  String _photoUrl = FirebaseAuth.instance.currentUser!.photoURL ?? '';

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  Future addDetails() async {
    FirestoreMethods.createUser(
            _auth.currentUser!.uid,
            _emailController.text.trim(),
            _usernameController.text.toLowerCase().trim(),
            _firstnameController.text.trim(),
            _lastnameController.text.trim(),
            Timestamp.fromMillisecondsSinceEpoch(
                DateTime.parse(_birthdayController.text)
                    .millisecondsSinceEpoch),
            _mobileController.text.trim(),
            _photoUrl)
        .whenComplete(() {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DrawerMenu(),
          ));
    });
  }

  @override
  void initState() {
    _emailController.text = _auth.currentUser!.email!;
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _firstnameController.dispose();
    _lastnameController.dispose();
    _birthdayController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemStatusBarContrastEnforced: false,
        systemNavigationBarContrastEnforced: false,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Form(
          key: _key,
          child: Center(
            child: SizedBox(
              width: 400,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final XFile? image = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            File file = File(image!.path);
                            _photoUrl = await StorageMethods.uploadFile(file);
                            setState(() {});
                          },
                          child: // Avatar
                              _photoUrl.isEmpty
                                  ? defaultAvatar()
                                  : networkAvatar(_photoUrl),
                        ),

                        distanceHeight(20),

                        const Text(
                          'Add your user details below!',
                          style: TextStyle(fontSize: 18),
                        ),

                        distanceHeight(20),

                        // details
                        AutofillGroup(
                          child: Column(
                            children: [
                              // email
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailController,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(Icons.email_outlined),
                                    focusColor: const Color(0xFF00a9ce),
                                    disabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xFF00a9ce)),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xFFB00000)),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xFFB00000)),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    labelText: 'Email',
                                    filled: false,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),

                              // username
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  controller: _usernameController,
                                  validator: _usernameValidator,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                        Icons.account_circle_outlined),
                                    focusColor: const Color(0xFF00a9ce),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xFF00a9ce)),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xFFB00000)),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xFFB00000)),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    labelText: 'Username',
                                    hintText:
                                        _auth.currentUser!.email!.split('@')[0],
                                    filled: true,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),

                              // firstname
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  controller: _firstnameController,
                                  validator: _firstnameValidator,
                                  decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(Icons.face_unlock_outlined),
                                    focusColor: const Color(0xFF00a9ce),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xFF00a9ce)),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xFFB00000)),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xFFB00000)),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    labelText: 'Firstname',
                                    filled: true,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),

                              // lastname
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: _lastnameController,
                                  validator: _lastnameValidator,
                                  decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(Icons.face_unlock_outlined),
                                    focusColor: const Color(0xFF00a9ce),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xFF00a9ce)),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xFFB00000)),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xFFB00000)),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    labelText: 'Lastname',
                                    filled: true,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),

                              // birthday
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: TextFormField(
                                  keyboardType: TextInputType.datetime,
                                  controller: _birthdayController,
                                  readOnly: true,
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime.now());

                                    if (pickedDate != null) {
                                      String formattedDate =
                                          DateFormat('yyyy-MM-dd')
                                              .format(pickedDate);

                                      setState(() {
                                        _birthdayController.text =
                                            formattedDate; //set output date to TextField value.
                                      });
                                    } else {
                                      print("Date is not selected");
                                    }
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(Icons.event_outlined),
                                    focusColor: const Color(0xFF00a9ce),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xFF00a9ce)),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xFFB00000)),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xFFB00000)),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    labelText: 'Birthday',
                                    filled: true,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),

                              // mobile
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: TextFormField(
                                  keyboardType: TextInputType.phone,
                                  onFieldSubmitted: (value) => addDetails(),
                                  controller: _mobileController,
                                  validator: _mobileValidator,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.call_outlined),
                                    focusColor: const Color(0xFF00a9ce),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xFF00a9ce)),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xFFB00000)),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xFFB00000)),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    labelText: 'Mobile',
                                    filled: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        distanceHeight(25),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: SlideAction(
                            borderRadius: 12,
                            elevation: 0,
                            innerColor: Colors.white,
                            outerColor: const Color(0xFF00a9ce),
                            sliderButtonIcon: const Icon(Icons.save,
                                color: Color(0xFF00a9ce)),
                            sliderRotate: false,
                            text: 'Slide to save',
                            onSubmit: () => addDetails(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // TODO VALIDATORS FIX
  String? _usernameValidator(String? username) {
    if (username == null || username.isEmpty) {
      return 'Username is required.';
    }

    String pattern =
        r"^[a-zA-Z0-9](_(?!(\.|_))|\.(?!(_|\.))|[a-zA-Z0-9]){6,18}[a-zA-Z0-9]$";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(username)) return 'Invalid username format.';

    return null;
  }

  String? _firstnameValidator(String? firstname) {
    if (firstname == null || firstname.isEmpty) {
      return 'Firstname is required.';
    }

    String pattern = r"^([a-z]+[,.]?[ ]?|[a-z]+['-]?)+$";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(firstname)) return 'Invalid firstname format.';

    return null;
  }

  String? _lastnameValidator(String? lastname) {
    if (lastname == null || lastname.isEmpty) {
      return 'Lastname is required.';
    }

    String pattern = r"^([a-z]+[,.]?[ ]?|[a-z]+['-]?)+$";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(lastname)) return 'Invalid lastname format.';

    return null;
  }

  String? _mobileValidator(String? mobile) {
    if (mobile == null || mobile.isEmpty) {
      return 'Mobile number is required.';
    }

    // security
    String pattern = r"^(\+?\d{1,4}[\s-])?(?!0+\s+,?$)\d{10}\s*,?$";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(mobile)) return 'Invalid mobile number format.';

    return null;
  }
}
