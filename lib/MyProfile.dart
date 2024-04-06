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

  String formatNumber(int number) {
    if (number >= 1000 && number < 1000000) {
      double result = number / 1000.0;
      return '${result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1)}k';
    } else if (number >= 1000000) {
      double result = number / 1000000.0;
      return '${result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1)}M';
    } else {
      return number.toString();
    }
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
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("pp.png"), fit: BoxFit.fill)),
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 32),
                Center(
                  child: Container(
                    width: 150,
                    height: 150,
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
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 7),
                Text(user.username.toString(),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    )),
                SizedBox(height: 31),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 48,
                    decoration: BoxDecoration(color: Color(0xFF141414)),
                    padding:
                        EdgeInsets.only(left: 11, right: 11, top: 8, bottom: 8),
                    child: Row(
                      children: [
                        Spacer(),
                        Image.asset(
                          "coin.png",
                          width: 32,
                          height: 32,
                          fit: BoxFit.fill,
                        ),
                        Text(formatNumber(user.coins!.toInt()),
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.normal)),
                        Spacer(),
                        Image.asset(
                          "logo.PNG",
                          width: 32,
                          height: 32,
                          fit: BoxFit.fill,
                        ),
                        Text(user.hattricks.toString(),
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.normal)),
                        Spacer(),
                        Image.asset(
                          "xp.png",
                          width: 32,
                          height: 32,
                          fit: BoxFit.fill,
                        ),
                        Text(
                            formatNumber(
                                auth.currentuser!.practice_points!.toInt()),
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.normal)),
                        Spacer()
                      ],
                    )),
                SizedBox(height: 31),
                GestureDetector(
                  onTap: user.is_subscribed
                      ? () async {
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
                        }
                      : () {},
                  child: Container(
                    width: 216,
                    height: 37,
                    decoration: BoxDecoration(color: Colors.white),
                    child: Center(
                        child: auth.currentuser!.is_subscribed
                            ? Text("View Stats",
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500))
                            : Text("Go Premium",
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500))),
                  ),
                ),
                SizedBox(height: 10),
                auth.currentuser!.is_subscribed == false
                    ? Text(
                        " Premium users have advantage over everything, premium users can play up to 5 games \n everyday and earn 10,000NGN on every game passed, they can also participate in Super league \n and earn up to 1,000,000NGN at the end of the month",
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 6,
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      )
                    : Container(),
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
