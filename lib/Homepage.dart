import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hattrick/AuthPage.dart';
import 'package:hattrick/main.dart';
import 'package:intl/intl.dart';
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

  void ShowLogOut() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            content: Container(
              height: 147,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Color(0xFF161616)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Are You Sure You Want to Log Out?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                  SizedBox(height: 23),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 72,
                          height: 22,
                          decoration: BoxDecoration(
                              color: Color(0xFF1D1D1D),
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                            child: Text(
                              'No',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          auth.logOut();
                          print("Werey wan log out");
                          runApp(MyApp());
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => AuthPage(),
                            ),
                          );
                        },
                        child: Container(
                          width: 72,
                          height: 22,
                          decoration: BoxDecoration(
                              color: Color(0xFFFFD2D7),
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                            child: Text(
                              'Yes',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###,###');
    if (auth.currentuser != null) {
      print(auth.currentuser!.coins);
      return Scaffold(
          backgroundColor: Color(0xFF1D1D1D),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: ListView(
              children: [
                Row(
                  children: [
                    Text(
                      "Hello, \n${auth.currentuser!.FullName.toString() == null ? "User" : auth.currentuser!.username.toString()}",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 36,
                          color: Colors.white),
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: () {
                          ShowLogOut();
                        },
                        icon: Icon(
                          Icons.logout,
                          color: Colors.redAccent[200],
                          weight: 1.5,
                        ))
                  ],
                ),
                Row(
                  children: [
                    Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(190)),
                      child: Image.asset(
                        "assets/Homepage/coin.png",
                        width: 16.95,
                        height: 15.11,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Text(
                      "${formatter.format(
                        auth.currentuser!.coins,
                      )}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        height: 0,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      child: Container(
                          width: 98.88,
                          height: 28,
                          decoration: BoxDecoration(
                              color: Color(0xFFFFD2D7),
                              borderRadius: BorderRadius.circular(50)),
                          child: Center(
                            child: Text(
                              'Buy Coins',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF322653),
                                fontSize: 12,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                          )),
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
