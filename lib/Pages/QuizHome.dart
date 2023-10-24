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
import 'package:rive/rive.dart';
import 'package:rive_loading/rive_loading.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:flutter_paystack/flutter_paystack.dart';

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
    dynamic response =
        await http.get(Uri.parse('http://localhost:5000/get-three'));

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
                                          "http://localhost:5000/playable"),
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
                                      color: Color(0xFFAF89F6),
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
                  GestureDetector(
                    onTap: () async {
                      final response = await http.post(
                        Uri.parse("http://localhost:5000/playable"),
                        body: jsonEncode(<String, String>{
                          'uid': auth.currentuser!.uid.toString()
                        }),
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                        },
                      );
                      final data = jsonDecode(response.body);
                      if (data['coins'] < 1) {
                        ScaffoldMessenger.of(context).showMaterialBanner(
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
                            builder: (BuildContext context) => new QuizPage(
                              type: QuizType.Practice_Play,
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                        width: 150,
                        height: 47,
                        decoration: ShapeDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Center(
                          child: Text("New Game",
                              style: GoogleFonts.poppins(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              )),
                        )),
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
                                color: Color(0xFFAF89F6),
                                decoration: TextDecoration.underline,
                                fontSize: 12)),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width - 60,
                    decoration: ShapeDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(children: [
                        for (var user in leads)
                          ListTile(
                            //textColor: Colors.white,
                            tileColor: Color(0xFF1D1D1D),
                            title: Text(user.username),
                            onTap: () async {
                              final response = await http.post(
                                Uri.parse("http://localhost:5000/userlytics"),
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
                            subtitle: Text('Super Points: ${user.superPoints}'),
                            trailing: Text("${leads.indexOf(user) + 1}"),
                            leading: SvgPicture.network(user.city,
                                width: 20, height: 20),
                          )
                      ]),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
