import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hattrick/AuthPage.dart';
import 'package:hattrick/BuyCoins.dart';
import 'package:hattrick/Leaderboard.dart';
import 'package:hattrick/Models/quiz.dart';
import 'package:hattrick/Pages/QuizHome.dart';
import 'package:hattrick/Pages/Quizpage.dart';
import 'package:hattrick/VisitProfile.dart';
import 'package:hattrick/main.dart';
import 'package:intl/intl.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

import '../Homepage.dart';
import '../LeaderBoardwAppbar.dart';
import '../Models/user.dart';

class QuizHome extends StatefulWidget {
  const QuizHome({super.key});

  @override
  State<QuizHome> createState() => _QuizHomeState();
}

class _QuizHomeState extends State<QuizHome> {
  List<AUser> leads = [];
  final auth = HattrickAuth();
  bool isMounted = false;
  @override
  void initState() {
    super.initState();
    isMounted = true; // Set isMounted to true when the widget is mounted
    auth.PasswordlessSignIn().then((_) {
      if (isMounted) {
        setState(() {}); // Refresh the widget after sign-in.
      }
    });
    //_startPaystack();
    fetchUsers();
  }

  @override
  void dispose() {
    isMounted = false; // Set isMounted to false when the widget is disposed
    super.dispose();
  }

  Future<void> fetchUsers() async {
    dynamic response = await http.get(Uri.parse(
        'https://hattrick-server-production.up.railway.app//get-three'));

    if (isMounted) {
      // Check if the widget is still mounted
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          leads = data.map((userJson) => AUser.fromJson(userJson)).toList();
        });
      } else {
        throw Exception('Failed to load users');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1D1D1D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: auth.currentuser == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Text("Your Super League Points -",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                              color: Colors.white)),
                      Spacer(),
                      Text(auth.currentuser!.super_points.toString(),
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                              color: Colors.white))
                    ],
                  ),
                  Row(
                    children: [
                      Text("Your Practice Points -",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                              color: Colors.white)),
                      Spacer(),
                      Text(auth.currentuser!.practice_points.toString(),
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                              color: Colors.white))
                    ],
                  ),
                  SizedBox(height: 12),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 190,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30)),
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Row(
                            children: [
                              Text("Super League",
                                  textAlign: TextAlign.left,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 28)),
                              Spacer()
                            ],
                          ),
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Text(
                              "Join The League and stand a chance to win up to 10,000,000 Naira",
                              textAlign: TextAlign.left,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w300, fontSize: 14)),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Row(
                            children: [
                              Spacer(),
                              GestureDetector(
                                onTap: () async {
                                  if (auth.currentuser!.is_subscribed) {
                                    final response = await http.post(
                                      Uri.parse(
                                          "https://hattrick-server-production.up.railway.app//playable"),
                                      body: jsonEncode(<String, String>{
                                        'uid': auth.currentuser!.uid.toString()
                                      }),
                                      headers: <String, String>{
                                        'Content-Type':
                                            'application/json; charset=UTF-8',
                                      },
                                    );
                                    final data = jsonDecode(response.body);
                                    if (data['coins'] < 1) {
                                      ScaffoldMessenger.of(context)
                                          .showMaterialBanner(
                                        MaterialBanner(
                                          content:
                                              Text('Insufficient Coin Balance'),
                                          actions: [
                                            IconButton(
                                              icon: Icon(Icons.close),
                                              onPressed: () {
                                                ScaffoldMessenger.of(context)
                                                    .hideCurrentMaterialBanner();
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              new QuizPage(
                                            type: QuizType.Super_League,
                                          ),
                                        ),
                                      );
                                    }
                                  } else {
                                    //...(Get Verified)...
                                  }
                                },
                                child: Container(
                                  height: 45,
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(91, 0, 0, 0),
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 12.0,
                                          bottom: 12.0,
                                          left: 24,
                                          right: 24),
                                      child: Text(
                                        auth.currentuser!.is_subscribed
                                            ? "Play"
                                            : "Subscribe To Join",
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 14,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    padding: EdgeInsets.only(
                        left: 12.0, right: 12.0, top: 8.0, bottom: 12.0),
                    decoration: ShapeDecoration(
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Practice Play',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Put your skills on the test',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 12),
                        GestureDetector(
                            child: Container(
                                width: 121,
                                height: 34,
                                decoration: BoxDecoration(
                                    color: Color(0xFF89E2F6),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Center(
                                    child: Text(
                                  'Go',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ))),
                            onTap: () async {
                              final response = await http.post(
                                Uri.parse(
                                    "https://hattrick-server-production.up.railway.app//playable"),
                                body: jsonEncode(<String, String>{
                                  'uid': auth.currentuser!.uid.toString()
                                }),
                                headers: <String, String>{
                                  'Content-Type':
                                      'application/json; charset=UTF-8',
                                },
                              );
                              final data = jsonDecode(response.body);
                              if (data['coins'] < 1) {
                                ScaffoldMessenger.of(context)
                                    .showMaterialBanner(
                                  MaterialBanner(
                                    content: Text('Insufficient Coin Balance'),
                                    actions: [
                                      IconButton(
                                        icon: Icon(Icons.close),
                                        onPressed: () {
                                          ScaffoldMessenger.of(context)
                                              .hideCurrentMaterialBanner();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        new QuizPage(
                                      type: QuizType.Practice_Play,
                                    ),
                                  ),
                                );
                              }
                            })
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    padding: EdgeInsets.only(
                        left: 12.0, right: 12.0, top: 8.0, bottom: 12.0),
                    decoration: ShapeDecoration(
                      color: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Master\'s Quiz',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Win 10,000 Naira for every win',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 12),
                        GestureDetector(
                            child: Container(
                                width: 121,
                                height: 34,
                                decoration: BoxDecoration(
                                    color: Color(0xFFAF89F6),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Center(
                                    child: Text(
                                  auth.currentuser!.is_subscribed
                                      ? "Play"
                                      : "Subscribe To Join",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ))),
                            onTap: () async {
                              final response = await http.post(
                                Uri.parse(
                                    "https://hattrick-server-production.up.railway.app//playable"),
                                body: jsonEncode(<String, String>{
                                  'uid': auth.currentuser!.uid.toString()
                                }),
                                headers: <String, String>{
                                  'Content-Type':
                                      'application/json; charset=UTF-8',
                                },
                              );
                              final data = jsonDecode(response.body);

                              if (auth.currentuser!.is_subscribed) {
                                if (data['coins'] < 1) {
                                  ScaffoldMessenger.of(context)
                                      .showMaterialBanner(
                                    MaterialBanner(
                                      content:
                                          Text('Insufficient Coin Balance'),
                                      actions: [
                                        IconButton(
                                          icon: Icon(Icons.close),
                                          onPressed: () {
                                            ScaffoldMessenger.of(context)
                                                .hideCurrentMaterialBanner();
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          new QuizPage(
                                        type: QuizType.Masters_Game,
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                //..Verify..//
                              }
                            })
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  Row(
                    children: [
                      Text("Leaderboards",
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              fontSize: 24)),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  LeaderBoardBeta(),
                            ),
                          );
                        },
                        child: Text("See Full Board",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w800,
                                color: Color(0x5B89E2F6),
                                decoration: TextDecoration.underline,
                                fontSize: 12)),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding:
                          EdgeInsets.only(top: 0, bottom: 0, left: 0, right: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var user in leads)
                            GestureDetector(
                              // title: Text(user.username),
                              onTap: () async {
                                final response = await http.post(
                                  Uri.parse(
                                      "https://hattrick-server-production.up.railway.app/userlytics"),
                                  headers: <String, String>{
                                    'Content-Type':
                                        'application/json; charset=UTF-8',
                                  },
                                  body: jsonEncode(<String, String>{
                                    'username': user.username,
                                  }),
                                );
                                final data = jsonDecode(response.body);
                                final all_score = data['super_points'] +
                                    data['practice_points'];
                                double percentage = data['percentage'];
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        VisitProfile(
                                      userData: data,
                                    ),
                                  ),
                                );
                              },

                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "0${leads.indexOf(user) + 1}",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white
                                            .withOpacity(0.550000011920929),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(width: 11),
                                    Container(
                                      width: 20,
                                      height: 20,
                                      decoration: ShapeDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                              user.city.toString()),
                                          fit: BoxFit.cover,
                                        ),
                                        shape: OvalBorder(),
                                      ),
                                      //child: Image.network(flag.toString()),
                                    ),
                                    SizedBox(width: 9),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.username,
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          'Super League Points: ${user.superPoints}',
                                          style: GoogleFonts.poppins(
                                            color: Colors.white.withOpacity(
                                                0.7200000286102295),
                                            fontSize: 6,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        SizedBox(height: 15)
                                      ],
                                    )
                                  ]),

                              //subtitle: Text('Super Points: ${user.superPoints}'),
                              //trailing: Text("${leads.indexOf(user) + 1}")
                            )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
