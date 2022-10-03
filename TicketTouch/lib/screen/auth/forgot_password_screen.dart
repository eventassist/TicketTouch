import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PasswordForgotScreen extends StatefulWidget {
  const PasswordForgotScreen({Key? key}) : super(key: key);

  @override
  State<PasswordForgotScreen> createState() => _PasswordForgotScreenState();
}

class _PasswordForgotScreenState extends State<PasswordForgotScreen> {
  final _emailController = TextEditingController();

  Future _passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim())
          .then((value) => Future.delayed(const Duration(seconds: 2))
              .then((value) => Navigator.pop(context)));
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text('''Email to reset your password has been sent.
              Please check your spam folder and make sure you choose a secure password'''),
            );
          });
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF00a9ce),
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              'Enter your Email and we will send you a password reset link.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),

          const SizedBox(height: 15),

          // email text field
          AutofillGroup(
            child: Column(
              // email
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(" ")),
                    ],
                    autofillHints: const [AutofillHints.email],
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (value) => _passwordReset(),
                    controller: _emailController,
                    validator: _emailValidator,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email_outlined),
                      focusColor: const Color(0xFF00a9ce),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFF00a9ce)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFB00000)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFB00000)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelText: 'Email',
                      filled: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          MaterialButton(
            onPressed: _passwordReset,
            shape: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFF00a9ce)),
              borderRadius: BorderRadius.circular(12),
            ),
            color: const Color(0xFF00a9ce),
            child: const Text(
              'RESET PASSWORD',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  String? _emailValidator(String? formEmail) {
    if (formEmail == null || formEmail.isEmpty) {
      return 'E-mail address is required.';
    }
    String pattern = r'\w+@\w+\.\w+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(formEmail)) return 'Invalid E-mail Address format.';
    return null;
  }
}
