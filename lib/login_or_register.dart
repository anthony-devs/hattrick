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

class _LoginOrRegisterState extends State<LoginOrRegister> {
  PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    if (_pageController.hasClients) {
      final pageCount = 3;
      final newIndex = index.clamp(0, pageCount - 1);
      setState(() {
        _currentPage = newIndex;
      });
      _pageController.jumpToPage(newIndex);
    }
  }

  Widget _buildPageIndicator(int pageIndex) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      width: 8.0,
      height: 8.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: pageIndex == _currentPage ? Colors.blue : Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 29, 29, 29),
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: kIsWeb
                  ? GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onHorizontalDragEnd: (details) {
                        if (_pageController.hasClients) {
                          final currentPage = _pageController.page ?? 0;
                          final velocity = details.velocity.pixelsPerSecond.dx;
                          final newIndex = velocity > 0
                              ? currentPage.floor() - 1
                              : currentPage.ceil() + 1;
                          _onPageChanged(newIndex);
                        }
                      },
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (index) {
                          _onPageChanged(index);
                        },
                        children: [
                          Page1(),
                          Page2(),
                          Page3(),
                        ],
                      ),
                    )
                  : PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        _onPageChanged(index);
                      },
                      children: [
                        Page1(),
                        Page2(),
                        Page3(),
                      ],
                    ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3, // Number of pages
                (index) => _buildPageIndicator(index),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Login()), // Navigate to Login page
                      );
                    },
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 4,
                        height: 54,
                        child: Center(
                            child: Text("Log In",
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black))),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 218, 221, 216),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10))),
                      ),
                    ),
                  ),
                  SizedBox(width: 18),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Signup()), // Navigate to Register page
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 4,
                      height: 54,
                      child: Center(
                          child: Text("Register",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black))),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 244, 235, 175),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
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

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(
            child: Text(" Earn While \n You Play",
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 36),
                textAlign: TextAlign.center)),
        SizedBox(height: 65),
        Center(
            child: Text(
          " Get Awesome rewards for \n answering questions on events \n that have already happened",
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14),
          textAlign: TextAlign.center,
        )),
        SizedBox(height: 46),
        Image.asset(
          'assets/SplashScreen/payment.png',
          width: 246,
          height: 224,
        ),
      ],
    );
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(
            child: Text(" Compete \n Globally",
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 36),
                textAlign: TextAlign.center)),
        SizedBox(height: 65),
        Center(
            child: Text(
          " Compete with users all over \n the world and win big weekly. ",
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14),
          textAlign: TextAlign.center,
        )),
        SizedBox(height: 46),
        Image.asset(
          'assets/SplashScreen/earth.png',
          width: 246,
          height: 246,
        ),
      ],
    );
  }
}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(
            child: Text(" Earn \n Privately",
                style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 36),
                textAlign: TextAlign.center)),
        SizedBox(height: 65),
        Center(
            child: Text(
          " As a human, your privacy matters \n so we have decided to cut down \n information that is being \n collected from you ",
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14),
          textAlign: TextAlign.center,
        )),
        SizedBox(height: 46),
        Image.asset(
          'assets/SplashScreen/secure.png',
          width: 246,
          height: 246,
        ),
      ],
    );
  }
}
