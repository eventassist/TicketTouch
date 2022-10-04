import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tickettouch/screen/home/menu.dart';
import 'package:tickettouch/screen/auth/forgot_password_screen.dart';
import 'package:tickettouch/utils/helper_widgets.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback showRegisterScreen;

  const LoginScreen({Key? key, required this.showRegisterScreen})
      : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenSate();
}

class _LoginScreenSate extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String _error = '';
  bool _isLoading = false;

  Future signIn() async {
    setState(() {
      _error = '';
    });
    if (_key.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await _auth
            .signInWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim())
            .then((value) {
          // if user is verified and exist login else not verified or not exist
          if (_auth.currentUser != null && _auth.currentUser!.emailVerified) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const Menu()));
          } else if (!_auth.currentUser!.emailVerified) {
            _auth.currentUser!.sendEmailVerification().then((value) => showSnackBar(
                context,
                'Your email is not verified! Please check your spam folder if you can\'t find the verify mail.'));
          }
          setState(() => _isLoading = false);
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          _error = 'Incorrect password or Account doesn\'t exist.';
        } else if (e.code == 'wrong-password') {
          _error = 'Incorrect password or Account doesn\'t exist.';
        } else {
          _error = e.message!;
        }
        setState(() => _isLoading = false);
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
                          'LOGIN',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Welcome back, you\'ve been missed!',
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
                                  autofillHints: const [AutofillHints.email],
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
                                  autofillHints: const [AutofillHints.password],
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (value) => signIn(),
                                  onEditingComplete: () {},
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
                            ],
                          ),
                        ),

                        const SizedBox(height: 5),

                        // forgot password
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                          const PasswordForgotScreen(),
                                      transitionsBuilder: (_, a, __, c) =>
                                          SlideTransition(
                                        position: Tween<Offset>(
                                          begin: const Offset(2.0, 0.0),
                                          end: Offset.zero,
                                        ).animate(a),
                                        child: c,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Forgot password?   ',
                                  style: TextStyle(
                                    color: Color(0xFF66cbe2),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 15),

                        // sign in btn
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: GestureDetector(
                            onTap: () => signIn(),
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
                                        'SIGN IN',
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
                              'Don\'t have an account? ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: widget.showRegisterScreen,
                              child: const Text(
                                'Register now',
                                style: TextStyle(
                                  color: Color(0xFF66cbe2),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            children: const [
                              Expanded(
                                child: Divider(
                                  color: Colors.grey,
                                  height: 8.0,
                                  thickness: 0.75,
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                'OR',
                                style: TextStyle(color: Colors.grey),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.grey,
                                  height: 8.0,
                                  thickness: 0.75,
                                ),
                              )
                            ],
                          ),
                        ),
                        distanceHeight(10),
                        // social login
                        Padding(
                          padding: EdgeInsets.only(
                              left: 25, right: 25, bottom: systemNavBarPadding),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // TODO Social Icons
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const AlertDialog(
                                          title: Text('Facebook sign in'));
                                    },
                                  );
                                },
                                child: const Icon(
                                  Icons.facebook,
                                  color: Color(0xFF00a9ce),
                                  size: 30,
                                ),
                              ),
                              const SizedBox(width: 30),
                              GestureDetector(
                                onTap: () {},
                                child: const Icon(
                                  Icons.g_mobiledata,
                                  color: Color(0xFF00a9ce),
                                  size: 50,
                                ),
                              ),
                              const SizedBox(width: 30),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return const AlertDialog(
                                          title: Text('Phone sign in'));
                                    },
                                  );
                                },
                                child: const Icon(
                                  Icons.call,
                                  color: Color(0xFF00a9ce),
                                  size: 30,
                                ),
                              ),
                            ],
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

    return null;
  }
}
