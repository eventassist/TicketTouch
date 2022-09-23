import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tickettouch/screen/account/login_screen.dart';

import 'onbaording_page_3.dart';
import 'onboarding_page_1.dart';
import 'onboarding_page_2.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  // controller to keep track of witch page we're on
  final PageController _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // keep track of if we are on the last page or not
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {

    final double additionalBottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                isLastPage = (index == 2);
              });
            },
            children: const [
              OnBoardingPage1(),
              OnBoardingPage2(),
              OnBoardingPage3(),
            ],
          ),
          // dot indicator
          Column(
            children: <Widget>[
              Flexible(
                  flex: 10,
                  child: Container(
                      // color: Colors.green,
                      )),
              Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // dot indicator
                    SmoothPageIndicator(
                        controller: _controller,
                        count: 3,
                        effect: const ExpandingDotsEffect(
                            dotHeight: 10,
                            dotWidth: 10,
                            spacing: 10,
                            dotColor: Colors.white,
                            activeDotColor: Colors.white),
                        onDotClicked: (index) {
                          _controller.animateToPage(index,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        }),
                  ],
                ),
              ),
              isLastPage == false
                  ? Padding(
                      padding: EdgeInsets.only(
                          left: 45, right: 45, bottom: 45 + additionalBottomPadding, top: 15),
                      child: SizedBox(
                        width: 700,
                        height: 48,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            TextButton(
                                onPressed: () {
                                  _controller.animateToPage(2,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeIn);
                                },
                                child: const Text(
                                  'SKIP',
                                  style: TextStyle(color: Colors.white),
                                )),
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  overlayColor:
                                      MaterialStateProperty.all(Colors.grey),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.black54),
                                  elevation: MaterialStateProperty.all(0.0),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ))),
                              child: const Text("NEXT"),
                              onPressed: () {
                                _controller.nextPage(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeIn);
                              },
                            )
                          ],
                        ),
                      ))
                  : Padding(
                      padding: EdgeInsets.only(
                          left: 45, right: 45, bottom: 45 + additionalBottomPadding, top: 15),
                      child: SizedBox(
                        width: 700,
                        height: 48,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              overlayColor:
                                  MaterialStateProperty.all(Colors.grey),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.black54),
                              elevation: MaterialStateProperty.all(0.0),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ))),
                          child: const Text("GET STARTED"),
                          onPressed: () async {
                            // navigate directly to home page or login screen
                            final prefs = await SharedPreferences.getInstance();
                            prefs.setBool('showOnBoarding', false).then(
                              // navigate to login screen
                                (value) => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LogInScreen())));
                          },
                        ),
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
