import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hattrick/AuthPage.dart';
import 'package:hattrick/main.dart';
import 'package:intl/intl.dart';
import 'package:rive/rive.dart';
import 'package:rive_loading/rive_loading.dart';
import 'Models/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class AUser {
  final String username;
  final int superPoints;

  AUser({required this.username, required this.superPoints});

  factory AUser.fromJson(Map<String, dynamic> json) {
    return AUser(
      username: json['username'],
      superPoints: json['super_points'],
    );
  }
}

class _HomePageState extends State<HomePage> {
  final auth = HattrickAuth();
  List<AUser> leads = [];
  @override
  void initState() {
    super.initState();
    auth.PasswordlessSignIn().then((_) {
      setState(() {}); // Refresh the widget after sign-in.
    });
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final response =
        await http.get(Uri.parse('http://localhost:5000/get-board'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        leads = data.map((userJson) => AUser.fromJson(userJson)).toList();
      });
    } else {
      throw Exception('Failed to load users');
    }
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
    final formatter = NumberFormat('#,###,###,###,###,###');
    if (auth.currentuser != null) {
      print(auth.currentuser!.coins);
      return Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: ListView(
              children: [
                SizedBox(height: 66),
                Row(
                  children: [
                    SizedBox(
                      width: 190,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Welcome, ',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 36,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: 'John',
                              style: GoogleFonts.poppins(
                                color: Color(0xFF322653),
                                fontSize: 36,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
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
                SizedBox(height: 22),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Color.fromARGB(73, 74, 74, 74),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),
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
                          decoration: ShapeDecoration(
                            color: Color(0xFFAF89F6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
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
                    ),
                  ],
                ),
                SizedBox(height: 23),
                Row(
                  children: [
                    SizedBox(height: 18.93),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 183,
                      decoration: ShapeDecoration(
                        color: Color(0xFFE3D7FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 18.93),
                              Text('Earnings',
                                  style: GoogleFonts.poppins(
                                    color: Color(0xFF8C75BC),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                    height: 0,
                                  )),
                              SizedBox(height: 21.72),
                              Container(
                                width: 178,
                                child: Text(
                                    "\$ ${formatter.format(auth.currentuser!.earning_balance)}",
                                    style: GoogleFonts.poppins(
                                      color: Color(0xFF8C75BC),
                                      fontSize: 32,
                                      fontWeight: FontWeight.w600,
                                      height: 0,
                                    )),
                              ),
                              SizedBox(height: 43.07),
                              GestureDetector(
                                child: Container(
                                    width: 98.88,
                                    height: 28,
                                    decoration: ShapeDecoration(
                                      color: Color(0xFFAF89F6),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Withdraw',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          color: Color(0xFF322653),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          height: 0,
                                        ),
                                      ),
                                    )),
                                onTap: () {
                                  //...(Withdraw)...
                                },
                              ),
                            ],
                          )),
                    ),
                    SizedBox(width: 16),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: ShapeDecoration(
                    color: Color(0xFF322653),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Expanded(
                    child: ListView(
                      children: [
                        Text('Leaderboard'),
                        for (var user in leads)
                          ListTile(
                            title: Text(user.username),
                            subtitle: Text('Super Points: ${user.superPoints}'),
                          ),
                      ],
                    ),
                  ),
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
