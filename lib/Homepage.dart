// ignore_for_file: file_names, prefer_const_constructors, use_build_context_synchronously
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hattrick/AuthPage.dart';
import 'package:hattrick/BuyCoins.dart';
import 'package:hattrick/NotificationsPage.dart';
import 'package:hattrick/Pages/QuizHome.dart';
import 'package:hattrick/Pages/Quizpage.dart';
import 'package:hattrick/VisitProfile.dart';
import 'package:hattrick/main.dart';
import 'package:intl/intl.dart';
//import 'package:rive_loading/rive_loading.dart';
import 'CoinPacksPage.dart';
import 'LeadHome.dart';
//import 'Models/news.dart';
import 'Models/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class AUser {
  final String username;
  final int superPoints;
  final String city;

  AUser(
      {required this.username, required this.superPoints, required this.city});

  factory AUser.fromJson(Map<String, dynamic> json) {
    return AUser(
        username: json['username'],
        superPoints: json['super_points'],
        city: json['city']);
  }
}

class News {
  final String? text;
  final String? category;

  News({required this.text, required this.category});

  factory News.fromJson(Map<String, dynamic> json) {
    return News(text: json['text'], category: json['category']);
  }
}

enum NewsTypes { Quiz, Practice, Masters, Super, News, Info }

class _HomePageState extends State<HomePage> {
  final auth = HattrickAuth();
  List<AUser> leads = [];
  List<News> news = [];
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
    getNews();
  }

  @override
  void dispose() {
    isMounted = false; // Set isMounted to false when the widget is disposed
    super.dispose();
  }

  void currency(context) {
    Locale locale = Localizations.localeOf(context);

    var format =
        NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'NGN');
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
    //while (true) {
    //sleep(Duration(seconds: 15));
    //fetchUsers();
    //}

    print("Got Users");
  }

  Future<void> getNews() async {
    dynamic response = await http.get(
        Uri.parse('https://hattrick-server-production.up.railway.app/news'));

    if (isMounted) {
      // Check if the widget is still mounted
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          news = data.map((newsJson) => News.fromJson(newsJson)).toList();
        });
      } else {
        throw Exception('Failed to load news');
      }
    }
    //while (true) {
    //sleep(Duration(seconds: 15));
    //fetchUsers();
    //}
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
    Locale locale = Localizations.localeOf(context);
    var format =
        NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'NGN');
    final formatter = NumberFormat('#,###,###,###,###,###');
    String balance =
        "${format.currencySymbol} ${auth.currentuser!.earning_balance}";
    int alpha = 0x5C; // 92 in decimal

    // Define the color with transparency
    Color myColor = Color.fromRGBO(0x89, 0xE2, 0xF6, alpha / 255.0);
    if (auth.currentuser != null) {
      //print(auth.currentuser!.coins);
      return Scaffold(
        backgroundColor: Color(0xFF0B0B0B),
        body: RefreshIndicator(
          onRefresh: () async {
            isMounted =
                true; // Set isMounted to true when the widget is mounted
            auth.PasswordlessSignIn().then((_) {
              if (isMounted) {
                setState(() {}); // Refresh the widget after sign-in.
              }
            });
            //_startPaystack();
            fetchUsers();
          },
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: ListView(
              children: [
                SizedBox(height: 66),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 94,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Welcome, ',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: auth.currentuser!.FullName.toString(),
                              style: GoogleFonts.poppins(
                                color: Color.fromARGB(176, 137, 153, 246),
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
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => Notifications(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.notifications,
                        color: Color.fromARGB(60, 255, 255, 255),
                        weight: 1.5,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 22),

                SizedBox(height: 25),
                Container(
                  width: MediaQuery.of(context).size.width - 60,
                  //height: 114,
                  padding:
                      EdgeInsets.only(top: 19, bottom: 5, left: 25, right: 25),
                  decoration: ShapeDecoration(
                    color: Color(0xFFFFAA6D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        news.last.category ?? "Category",
                        style: GoogleFonts.poppins(
                          color: Colors.black.withOpacity(0.6000000238418579),
                          fontSize: 6,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      SizedBox(
                        width: 279,
                        child: Text(
                          news.last.text ?? "Text",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(height: 6),
                      GestureDetector(
                        onTap: () {
                          News item = news.last;
                          List<NewsTypes?> categories = [
                            NewsTypes.Info,
                            NewsTypes.Masters,
                            NewsTypes.News,
                            NewsTypes.Practice,
                            NewsTypes.Quiz,
                            NewsTypes.Super
                          ];
                          NewsTypes category;
                          for (var type in categories) {
                            if (type
                                .toString()
                                .contains(item.category ?? "Category")) {
                              category = type!;
                              if (category == NewsTypes.Quiz ||
                                  category == NewsTypes.Masters ||
                                  category == NewsTypes.Practice ||
                                  category == NewsTypes.Super) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        QuizHome(),
                                  ),
                                );
                              } else if (category == NewsTypes.News ||
                                  category == NewsTypes.Info) {}
                            }
                          }
                        },
                        child: Container(
                          width: 156.30,
                          height: 30,
                          child: Center(
                            child: Text(
                              'Go',
                              style: GoogleFonts.poppins(
                                color: Color(0xFFFFAA6D),
                                fontSize: 6,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          decoration: ShapeDecoration(
                            color: Color(0xFF0B0B0B),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 23),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 183,
                  padding:
                      EdgeInsets.only(top: 19, bottom: 5, left: 25, right: 25),
                  decoration: ShapeDecoration(
                    color: myColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: !auth.currentuser!.is_subscribed
                        ? [
                            SizedBox(height: 21.72),
                            //This one fi cause error
                            SizedBox(
                                width: 178,
                                height: 43.27,
                                child: Text('Get Verified To Start Earning',
                                    style: GoogleFonts.poppins(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ))),
                            SizedBox(height: 25.07),
                            GestureDetector(
                              child: Container(
                                width: 195.29,
                                height: 36.06,
                                decoration: ShapeDecoration(
                                  color: Color.fromARGB(255, 137, 226, 246),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Get Verified',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
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
                            Text(
                              'Earnings',
                              style: GoogleFonts.poppins(
                                color: Color(0x5B89E2F6),
                                fontSize: 13,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            SizedBox(height: 21.72),
                            Container(
                              //width: 178,
                              child: Text(
                                balance,
                                style: GoogleFonts.poppins(
                                  color: Color(0x5B89E2F6),
                                  fontSize: 32,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(height: 15.07),
                            GestureDetector(
                              child: Container(
                                width: 98.88,
                                height: 28,
                                decoration: ShapeDecoration(
                                  color: Color(0xFF89E2F6),
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
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                //...(Withdraw)...
                                showInfo(
                                    "Feature Not Yet Implemented, Upgrade to Stable Version",
                                    Colors.red);
                              },
                            ),
                          ],
                  ),
                ),
                SizedBox(width: 16),
                SizedBox(height: 30),

                CarouselSlider(
                  options: CarouselOptions(
                      height: 102,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 9),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      viewportFraction: 1.2
                      //itemMargin: 16
                      ),
                  items: [
                    Container(
                        width: MediaQuery.of(context).size.width - 35,
                        height: 99,
                        padding: EdgeInsets.only(
                            left: 25, right: 25, top: 15, bottom: 15),
                        decoration: ShapeDecoration(
                          color: Color(0xFF6DB9FF),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  auth.currentuser!.is_subscribed
                                      ? 'Play in The League and Stand a Chance to win Big'
                                      : 'Join The League and Stand a Chance to win Big',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  )),
                              GestureDetector(
                                onTap: () {
                                  if (auth.currentuser!.is_subscribed) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            QuizHome(),
                                      ),
                                    );
                                  } else {
                                    //...Verify...
                                  }
                                },
                                child: Container(
                                  width: 156.30,
                                  height: 30,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFF0B0B0B),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Center(
                                      child: Text(
                                    auth.currentuser!.is_subscribed
                                        ? 'Play Now'
                                        : 'Subscribe To Join',
                                    style: GoogleFonts.poppins(
                                      color: Color(0xFF6DB9FF),
                                      fontSize: 6,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )),
                                ),
                              )
                            ])),

//2

                    Container(
                        width: MediaQuery.of(context).size.width - 35,
                        height: 99,
                        padding: EdgeInsets.only(
                            left: 25, right: 25, top: 15, bottom: 15),
                        decoration: ShapeDecoration(
                          color: Color(0xFF826DFF),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Play Practice Games to get a glimpse of the world of Hattrick',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  )),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          QuizHome(),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 156.30,
                                  height: 30,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFF0B0B0B),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Center(
                                      child: Text(
                                    'Play Now',
                                    style: GoogleFonts.poppins(
                                      color: Color(0xFF826DFF),
                                      fontSize: 6,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )),
                                ),
                              )
                            ])),

                    Container(
                        width: MediaQuery.of(context).size.width - 35,
                        height: 99,
                        padding: EdgeInsets.only(
                            left: 25, right: 25, top: 15, bottom: 15),
                        decoration: ShapeDecoration(
                          color: Color(0xFF8AFF6D),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  ' Play and Earn with Master’s Quiz \n Earn Up To N10,000 for each quiz',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  )),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          QuizHome(),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 156.30,
                                  height: 30,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFF0B0B0B),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Center(
                                      child: Text(
                                    'Play Now',
                                    style: GoogleFonts.poppins(
                                      color: Color(0xFF8AFF6D),
                                      fontSize: 6,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )),
                                ),
                              )
                            ])),

                    Container(
                        width: MediaQuery.of(context).size.width - 35,
                        height: 99,
                        padding: EdgeInsets.only(
                            left: 25, right: 25, top: 15, bottom: 15),
                        decoration: ShapeDecoration(
                          color: Color(0xFFFF7F6D),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Score A Hattrick and Win N1,000,000',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  )),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (BuildContext context) =>
                                          QuizHome(),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 156.30,
                                  height: 30,
                                  decoration: ShapeDecoration(
                                    color: Color(0xFF0B0B0B),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Center(
                                      child: Text(
                                    'Play Now',
                                    style: GoogleFonts.poppins(
                                      color: Color(0xFFFF7F6D),
                                      fontSize: 6,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )),
                                ),
                              )
                            ])),
                    // Add more containers for additional slides
                  ],
                ),

                SizedBox(height: 30),
                //Leaderboards!!!
                Text(
                  'Leaderboard',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 12),

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

                            child: Row(children: [
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
                                    image: NetworkImage(user.city.toString()),
                                    fit: BoxFit.cover,
                                  ),
                                  shape: OvalBorder(),
                                ),
                                //child: Image.network(flag.toString()),
                              ),
                              SizedBox(width: 9),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      color: Colors.white
                                          .withOpacity(0.7200000286102295),
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
        ),
      );
    } else {
      return Scaffold(
          backgroundColor: Color(0xFF1D1D1D),
          body: Center(child: CircularProgressIndicator()));
    }
  }

  void showInfo(err, Color color) {
    //print("rgba(${color.red}, ${color.green}, ${color.blue}, ${color.alpha})");
    setState(() {
      Fluttertoast.showToast(
          timeInSecForIosWeb: 4,
          gravity: ToastGravity.BOTTOM,
          webPosition: "center",
          webBgColor:
              "rgba(${color.red}, ${color.green}, ${color.blue}, ${color.alpha})",
          msg: err.toString(),
          textColor: Colors.white,
          backgroundColor: color,
          fontSize: 16.0);
    });
  }
}
