import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hattrick/AuthPage.dart';
import 'package:hattrick/Pages/Quizpage.dart';
import 'package:hattrick/VisitProfile.dart';
import 'package:hattrick/main.dart';
import 'package:intl/intl.dart';

import 'CoinPacksPage.dart';
import 'Homepage.dart';
import 'LeadHome.dart';
import 'Models/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

class MyProfile extends StatefulWidget {
  HattrickAuth auth;
  MyProfile({super.key, required this.auth});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  bool isMounted = false;
  String? flag;

  @override
  void initState() {
    super.initState();
    final auth = widget.auth;
    isMounted = true; // Set isMounted to true when the widget is mounted
    auth.PasswordlessSignIn().then((_) async {
      if (isMounted) {
        final countryFlag =
            await getCountryFlag(auth.currentuser!.city.toString());
        setState(() {
          flag = countryFlag;
        });
      }
    });
  }

  dynamic getUserlytics() async {
    final auth = widget.auth;
    final response = await http.post(
      Uri.parse(
          "https://hattrick-server-production.up.railway.app//userlytics"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': auth.currentuser!.username.toString(),
      }),
    );
    final data = jsonDecode(response.body);
    return data;
  }

  Future<String?> getCountryFlag(String countryName) async {
    final response = await http.get(
      Uri.parse('https://restcountries.com/v2/name/$countryName'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data[0]['flags']['png'];
    } else {
      return "Country not found";
    }
  }

  @override
  void dispose() {
    isMounted = false; // Set isMounted to false when the widget is disposed
    super.dispose();
  }

  void ShowLogOut() {
    final auth = widget.auth;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            content: Container(
              height: 147,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Color(0xFF161616)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Are You Sure You Want to Log Out?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
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
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
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
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
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
    final auth = widget.auth;
    Locale locale = Localizations.localeOf(context);
    var format = "NGN";
    final formatter = NumberFormat('#,###,###,###,###,###');

    final user = auth.currentuser;
    print(flag);
    if (user != null) {
      String balance = " ${auth.currentuser!.earning_balance}";
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: ListView(children: [
            SizedBox(height: 75),
            Row(
              children: [
                Text(
                  'Profile',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
                Spacer(),
                IconButton(
                    onPressed: () async {
                      final response = await http.post(
                        Uri.parse(
                            "https://hattrick-server-production.up.railway.app//userlytics"),
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                        body: jsonEncode(<String, String>{
                          'username': auth.currentuser!.username.toString(),
                        }),
                      );
                      final data = await jsonDecode(response.body);
                      final all_score =
                          data['super_points'] + data['practice_points'];
                      double percentage = data['percentage'];
                      await Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => VisitProfile(
                            userData: data,
                          ),
                        ),
                      );
                    },
                    icon: Icon(CupertinoIcons.chart_bar)),
              ],
            ),
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: NetworkImage(flag.toString()),
                    fit: BoxFit.cover,
                  ),
                  shape: OvalBorder(),
                ),
                //child: Image.network(flag.toString()),
              ),
            ),
            SizedBox(height: 21),
            Text(
              user.FullName.toString(),
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
            SizedBox(height: 7),
            Text(user.username.toString(),
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  height: 0,
                )),
            SizedBox(height: 26),
            Container(
              width: MediaQuery.of(context).size.width - 40,
              height: 100,
              decoration: ShapeDecoration(
                color: Color(0xFFE9DCFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      auth.currentuser!.played.toString(),
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                    Text(
                      'Games Played',
                      style: GoogleFonts.poppins(
                        color: Colors.black.withOpacity(0.5799999833106995),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 73),
            Container(
                width: MediaQuery.of(context).size.width - 40,
                padding: EdgeInsets.all(21),
                height: 150,
                decoration: ShapeDecoration(
                  color: Color(0x5B89E2F6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: !auth.currentuser!.is_subscribed
                      ? [
                          SizedBox(height: 21.72),
                          //This one fi cause error
                          Text('Get Verified To Start Earning',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              )),
                          SizedBox(height: 18),
                          GestureDetector(
                            child: Container(
                              width: 98.88,
                              height: 28,
                              decoration: ShapeDecoration(
                                color: Color.fromARGB(91, 255, 255, 255),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Get Verified',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: Color(0xFF322653),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              //...(Verify)...
                            },
                          ),
                        ]
                      : [
                          SizedBox(height: 18.93),
                          Container(
                            width: 178,
                            child: Text(
                              balance,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                          GestureDetector(
                            child: Container(
                              width: 98.88,
                              height: 28,
                              decoration: ShapeDecoration(
                                color: Color.fromARGB(255, 255, 255, 255),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Withdraw',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              //...(Withdraw)...
                            },
                          ),
                        ],
                )),
            SizedBox(height: 12),
            Container(
                width: MediaQuery.of(context).size.width - 40,
                padding: EdgeInsets.all(21),
                height: 150,
                decoration: ShapeDecoration(
                  color: Color(0xFFE3D7FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 18.93),
                    Container(
                      width: 178,
                      child: Text(
                        "${formatter.format(auth.currentuser!.coins)} Coins Left",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    GestureDetector(
                      child: Container(
                        width: 98.88,
                        height: 28,
                        decoration: ShapeDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Buy Coins',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => CoinPacks(
                              auth: auth,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                )),
            SizedBox(height: 35),
            GestureDetector(
              onTap: () {
                ShowLogOut();
              },
              child: Center(
                  child: Container(
                width: 150,
                height: 40,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: Colors.deepOrange,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Log Out",
                    style: GoogleFonts.poppins(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )),
            ),
            SizedBox(
              height: 105,
            )
          ]),
        ),
      );
    } else {
      return Scaffold(
          backgroundColor: Colors.black,
          body: Center(child: CircularProgressIndicator()));
    }
  }
}
