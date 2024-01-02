// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_fonts/google_fonts.dart';
import 'Pages/signup.dart'; // Import the Login page
import 'Pages/login.dart'; // Import the Register page

class LoginOrRegister extends StatefulWidget {
  @override
  _LoginOrRegisterState createState() => _LoginOrRegisterState();
}

// ... (Your existing imports and class definitions)

class _LoginOrRegisterState extends State<LoginOrRegister> {
  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  final pageCount = 4; // Total number of pages

  bool _isMouseOver = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    final newIndex = index.clamp(0, pageCount - 1);
    if (_currentPage != newIndex) {
      setState(() {
        _currentPage = newIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 29, 29, 29),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: [
            Expanded(
              child: kIsWeb
                  ? MouseRegion(
                      onEnter: (_) {
                        // Enable scrolling on web when the mouse enters the widget
                        setState(() {
                          _isMouseOver = true;
                        });
                      },
                      onExit: (_) {
                        // Disable scrolling on web when the mouse exits the widget
                        setState(() {
                          _isMouseOver = false;
                        });
                      },
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onHorizontalDragEnd: (details) {
                          if (_isMouseOver && _pageController.hasClients) {
                            final currentPage = _pageController.page ?? 0;
                            final velocity =
                                details.velocity.pixelsPerSecond.dx;
                            final newIndex = velocity > 0
                                ? currentPage.floor() - 1
                                : currentPage.ceil() + 1;
                            _onPageChanged(newIndex);
                            if (newIndex == pageCount) {
                              // If the user swipes from the last page, jump to the first page
                              _pageController.jumpToPage(0);
                            }
                          }
                        },
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (index) {
                            _onPageChanged(index);
                          },
                          children: [
                            Center(
                              child: Column(children: [
                                SizedBox(height: 90),
                                Image.asset(
                                  "assets/logo.PNG",
                                  width: MediaQuery.of(context).size.width,
                                  height: 210,
                                ),
                                Text(
                                  'Hattrick',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 48,
                                    fontWeight: FontWeight.w800,
                                  ),
                                )
                              ]),
                            ),
                            Center(
                              child: Column(children: [
                                SizedBox(height: 62),
                                Image.asset(
                                  "assets/SplashScreen/quiz.png",
                                  width: 290,
                                ),
                                Text(
                                  'Quiz',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                  ),
                                )
                              ]),
                            ),
                            Center(
                              child: Column(children: [
                                SizedBox(height: 140),
                                Image.asset(
                                  "assets/SplashScreen/win.png",
                                  width: 290,
                                ),
                                Text(
                                  'Win',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                  ),
                                )
                              ]),
                            ),
                            Center(
                              child: Column(children: [
                                SizedBox(height: 65),
                                Image.asset(
                                  "assets/SplashScreen/payment.png",
                                  width: 290,
                                  height: 234.97,
                                ),
                                Text(
                                  'Earn',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                  ),
                                )
                              ]),
                            ),
                          ],
                        ),
                      ),
                    )
                  : PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        _onPageChanged(index);
                      },
                      children: [
                        Center(
                          child: Column(children: [
                            SizedBox(height: 90),
                            Image.asset(
                              "assets/logo.PNG",
                              width: MediaQuery.of(context).size.width,
                              height: 210,
                            ),
                            Text(
                              'Hattrick',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.w800,
                              ),
                            )
                          ]),
                        ),
                        Center(
                          child: Column(children: [
                            SizedBox(height: 65),
                            Image.asset(
                              "assets/SplashScreen/quiz.png",
                              width: 240,
                            ),
                            Text(
                              'Quiz',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                              ),
                            )
                          ]),
                        ),
                        Center(
                          child: Column(children: [
                            SizedBox(height: 130),
                            Image.asset(
                              "assets/SplashScreen/win.png",
                              width: 290,
                            ),
                            Text(
                              'Win',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                              ),
                            )
                          ]),
                        ),
                        Center(
                          child: Column(children: [
                            SizedBox(height: 90),
                            Image.asset(
                              "assets/SplashScreen/payment.png",
                              width: 290,
                              height: 234.97,
                            ),
                            Text(
                              'Earn',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                              ),
                            )
                          ]),
                        ),
                      ],
                    ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Signup(),
                        ),
                      );
                    },
                    child: Container(
                      width: 219.41,
                      height: 64,
                      decoration: ShapeDecoration(
                        color: Color(0xFF89E2F6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Register",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Login(),
                        ),
                      );
                    },
                    child: Container(
                      width: 219.41,
                      height: 64,
                      decoration: ShapeDecoration(
                        color: Color(0xFF89E2F6).withOpacity(0.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "Login",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w800,
                            color: Color(0xFFEA8843),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ... (Your existing classes)
