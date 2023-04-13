import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterScreen extends StatefulWidget {
  final VoidCallback showLoginScreen;

  const RegisterScreen({Key? key, required this.showLoginScreen})
      : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenSate();
}

class _RegisterScreenSate extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordAgainController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String _error = '';
  bool _isLoading = false;

  Future signUp() async {
    setState(() {
      _error = '';
    });
    if (_key.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await _auth
            .createUserWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim())
            .whenComplete(() {
          setState(
            () {
              _isLoading = false;
              _emailController.text = '';
              _passwordController.text = '';
              _passwordAgainController.text = '';
            },
          );
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          _error = 'The account already exists.';
        }
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double systemStatusBarPadding = MediaQuery.of(context).padding.top;
    final double systemNavBarPadding = MediaQuery.of(context).padding.bottom;

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
                        // placeholder
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25,
                              right: 25,
                              top: 25 + systemStatusBarPadding),
                          child: Row(
                            children: const [
                              //TODO: Header
                            ],
                          ),
                        ),
                        // logo
                        Container(
                          height: 110,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: const DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: AssetImage(
                                'assets/logos/1024.png',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),

                        // hello again
                        const Text(
                          'REGISTER',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Register below with your details!',
                          style: TextStyle(fontSize: 18),
                        ),

                        const SizedBox(height: 25),

                        // error msg
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Text(
                            _error,
                            style: const TextStyle(color: Color(0xFFB00000)),
                            textAlign: TextAlign.center,
                          ),
                        ),

                        const SizedBox(height: 5),

                        // email & password
                        AutofillGroup(
                          child: Column(
                            // email
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: TextFormField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(
                                        RegExp(" ")),
                                  ],
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  controller: _emailController,
                                  validator: _emailValidator,
                                  decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(Icons.email_outlined),
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
                                    labelText: 'Email',
                                    filled: true,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),

                              // password
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  controller: _passwordController,
                                  validator: _passwordValidator,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.lock_outline),
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
                                    labelText: 'Password',
                                    filled: true,
                                  ),
                                  obscureText: true,
                                ),
                              ),

                              const SizedBox(height: 10),

                              // password again
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (value) => signUp(),
                                  onEditingComplete: () {},
                                  controller: _passwordAgainController,
                                  validator: _passwordAgainValidator,
                                  decoration: InputDecoration(
                                    prefixIcon:
                                        const Icon(Icons.lock_reset_outlined),
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
                                    labelText: 'Confirm password',
                                    filled: true,
                                  ),
                                  obscureText: true,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        // error msg
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Text(''),
                        ),

                        const SizedBox(height: 10),

                        // sign up btn
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: GestureDetector(
                            onTap: () => signUp(),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color(0xFF00a9ce),
                              ),
                              child: Center(
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text(
                                        'SIGN UP',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                        // register swap
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'I have an account! ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: widget.showLoginScreen,
                              child: const Text(
                                'Login now',
                                style: TextStyle(
                                  color: Color(0xFF66cbe2),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // social login
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25,
                              right: 25,
                              bottom: 25 + systemNavBarPadding),
                          child: Row(
                            children: const [],
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

  String? _emailValidator(String? formEmail) {
    if (formEmail == null || formEmail.isEmpty) {
      return 'E-mail address is required.';
    }

    String pattern = r'\w+@\w+\.\w+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(formEmail)) return 'Invalid E-mail Address format.';

    return null;
  }

  String? _passwordValidator(String? formPassword) {
    if (formPassword == null || formPassword.isEmpty) {
      return 'Password is required.';
    }

    // security
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(formPassword)) {
      return '''Password does not meet security requirements.
      - at least 8 characters
      - an uppercase letter
      - a number''';
    }

    return null;
  }

  String? _passwordAgainValidator(String? formPassword) {
    if (formPassword == null || formPassword.isEmpty) {
      return 'Password repetition is required.';
    }

    // same passwords
    final firstPassword = _passwordController.text.trim();
    if (firstPassword != formPassword) {
      return 'Passwords do not match, please try again.';
    }

    return null;
  }
}
