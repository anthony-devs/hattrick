import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart';
import 'package:rive_loading/rive_loading.dart';
import 'Models/user.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final auth = HattrickAuth();
  @override
  void initState() {
    super.initState();
    auth.PasswordlessSignIn().then((_) {
      setState(() {}); // Refresh the widget after sign-in.
    });
  }

  @override
  Widget build(BuildContext context) {
    if (auth.currentuser != null) {
      return Scaffold(
          backgroundColor: Color(0xFF1D1D1D),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView(
              children: [
                Text(
                  "Hello, \n${auth.currentuser!.FullName.toString() == null ? "User" : auth.currentuser!.username.toString()}",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 36,
                      color: Colors.white),
                ),
                Row(
                  children: [
                    Container(
                      width: 62.56,
                      height: 38,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            top: 0,
                            child: Container(
                              width: 35,
                              height: 38,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    top: 3,
                                    child: Container(
                                      width: 35,
                                      height: 35,
                                      decoration: ShapeDecoration(
                                        color: Colors.black,
                                        shape: OvalBorder(),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    top: 0,
                                    child: Container(
                                      width: 35,
                                      height: 35,
                                      decoration: ShapeDecoration(
                                        color: Color(0xFF7161EF),
                                        shape: OvalBorder(),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 9,
                                    top: 10,
                                    child: Container(
                                      width: 16.95,
                                      height: 15.11,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/Homepage/coin.png'),
                                          //fit: BoxFit.contain,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 40.20,
                            top: 9,
                            child: SizedBox(
                              width: 22.37,
                              child: Text(
                                '16',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      child: Container(
                        width: 98.88,
                        height: 28,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Container(
                                width: 98.88,
                                height: 28,
                                decoration: ShapeDecoration(
                                  color: Color(0xFF2E9A6C),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 13.88,
                              top: 5,
                              child: SizedBox(
                                width: 71.80,
                                child: Text(
                                  'Buy Coins',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        //...(Buy Coins)...
                      },
                    )
                  ],
                )
              ],
            ),
          ));
    } else {
      return Scaffold(
          backgroundColor: Color(0xFF1D1D1D),
          body: Center(
              child: RiveAnimation.asset(
            'assets/load.riv',
          )));
    }
  }
}
