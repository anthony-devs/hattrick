// ignore_for_file: file_names, prefer_const_constructors, use_build_context_synchronously
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'dart:async';
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
import 'Models/quiz.dart';
import 'package:carousel_slider/carousel_slider.dart';

class League {
  final int id;
  final DateTime ends;
  final int prize;
  final List<String> players;

  League(
      {required this.id,
      required this.ends,
      required this.prize,
      required this.players});

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      id: json['id'],
      ends: DateTime.parse(json['ends']),
      prize: json['prize'],
      players: List<String>.from(json['players']),
    );
  }
}

class AUser {
  final String username;
  final int superPoints;
  final int hattricks;
  final int practice_points;
  final String city;

  AUser(
      {required this.username,
      required this.superPoints,
      required this.city,
      required this.hattricks,
      required this.practice_points});

  factory AUser.fromJson(Map<String, dynamic> json) {
    return AUser(
        username: json['username'],
        hattricks: json['hattricks'],
        practice_points: json['xp'],
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

class HomePage extends StatefulWidget {
  HattrickAuth auth;
  HomePage({super.key, required this.auth});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  String _formatDate(DateTime date) {
    // Format the date to "Month day, year" format
    return 'Ends ${_getMonthName(date.month)} ${date.day}, ${date.year}';
  }

  String _getMonthName(int month) {
    // Convert month number to month name
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  List<League> leagues = [];

  List<AUser> leads = [];
  List<AUser> all_leads = [];
  List<News>? news;
  late Future<User?> _user;

  Future<User?> userFuture() async {
    User? user = widget.auth.currentuser;
    return user;
  }

  bool isMounted = false;
  Future<void> getNews() async {
    dynamic response = await http.get(
        Uri.parse('https://hattrick-server-production.up.railway.app/news'));

    if (isMounted) {
      // Check if the widget is still mounted
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        news = data.map((newsJson) => News.fromJson(newsJson)).toList();
      } else {
        throw Exception('Failed to load news');
      }
    }
    //while (true) {
    //sleep(Duration(seconds: 15));
    //fetchUsers();
    //}
  }

  void fetchLeagues() async {
    final response = await http.get(Uri.parse(
        'https://hattrick-server-production.up.railway.app/get-leagues'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        leagues =
            data.map((leagueData) => League.fromJson(leagueData)).toList();
      });
    } else {
      throw Exception('Failed to load leagues');
    }
  }

  late Timer _timer;
  @override
  void initState() {
    super.initState();
    isMounted = true; // Set isMounted to true when the widget is mounted
    getNews();
    fetchLeagues();
    fetchUsers();
    _startTimer();
    isMounted = true; // Set isMounted to true when the widget is mounted
    widget.auth.PasswordlessSignIn();
    _user = userFuture();
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    isMounted = false; // Make sure to update isMounted
    super.dispose();
  }

  void _startTimer() {
    // Initialize the timer to refresh data every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      // Call the methods to fetch data from APIs
      widget.auth.PasswordlessSignIn().then((_) {
        getNews();
        if (isMounted) {
          setState(() {}); // Refresh the widget after sign-in.
        }
      });
      getNews();
      fetchLeagues();
      fetchUsers();
    });
  }

  void currency(context) {
    getNews();
    Locale locale = Localizations.localeOf(context);

    var format =
        NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'NGN');
  }

  Future<void> fetchUsers() async {
    getNews();
    dynamic response = await http.get(Uri.parse(
        'https://hattrick-server-production.up.railway.app//get-three'));

    if (isMounted) {
      // Check if the widget is still mounted
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          //leads = data.map((userJson) => AUser.fromJson(userJson)).toList();
        });
      } else {
        throw Exception('Failed to load users');
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
                          widget.auth.logOut();
                          print("Werey wan log out");
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
    getNews();
    Locale locale = Localizations.localeOf(context);
    //var format =
    //  NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'NGN');
    final formatter = NumberFormat('#,###,###,###,###,###');

    int alpha = 0x5C; // 92 in decimal

    // Define the color with transparency
    Color myColor = Color.fromRGBO(0x89, 0xE2, 0xF6, alpha / 255.0);
    Map<String, dynamic> me = {};

    all_leads.asMap().forEach((key, user) {
      if (user.username == auth.currentuser!.username) {
        me = {
          "position": key + 1,
          "username": user.username,
          "city": user.city
        };
      }
    });

    if (auth.currentuser != null || news != null) {
      //print(auth.currentuser!.coins);
      return Scaffold(
        backgroundColor: Color(0xFF0B0B0B),
        body: FutureBuilder<User?>(
            future: _user,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final user = snapshot.data;

                if (user!.earning_balance != null) {
                  String? balance = "${formatter.format(user.earning_balance)}";
                  return RefreshIndicator(
                    onRefresh: () async {
                      getNews();
                      isMounted =
                          true; // Set isMounted to true when the widget is mounted

                      //_startPaystack();
                      fetchUsers();
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/home.png"),
                              fit: BoxFit.cover)),
                      child: ListView(
                        children: [
                          SizedBox(height: 21),
                          GestureDetector(
                            onTap: user.is_subscribed
                                ? () {
                                    //...(Withdraw)...
                                    showInfo(
                                        "Feature Not Yet Implemented, Upgrade to Stable Version",
                                        Colors.red);
                                  }
                                : () {
                                    //...(Subscribe)...
                                  },
                            child: Row(
                              children: [
                                Spacer(),
                                Container(
                                  width: 159,
                                  height: 32,
                                  decoration:
                                      BoxDecoration(color: Color(0xFF141414)),
                                  child: Container(
                                      child: user.is_subscribed
                                          ? Row(children: [
                                              Spacer(),
                                              Text(balance,
                                                  style: GoogleFonts.poppins(
                                                      color: Color(0xFFDDDDDD),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.normal)),
                                              Text(
                                                "NGN",
                                                style: GoogleFonts.poppins(
                                                    color: Color(0xFFFFD700),
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              SizedBox(
                                                width: 12,
                                              )
                                            ])
                                          : Row(
                                              children: [
                                                Spacer(),
                                                Text(
                                                    "Get Verified to start earning",
                                                    style: GoogleFonts.poppins(
                                                        color:
                                                            Color(0xFFDDDDDD),
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.normal)),
                                                SizedBox(width: 12)
                                              ],
                                            )),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 7),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              height: 48,
                              decoration:
                                  BoxDecoration(color: Color(0xFF141414)),
                              padding: EdgeInsets.only(
                                  left: 11, right: 11, top: 8, bottom: 8),
                              child: Row(
                                children: [
                                  Spacer(),
                                  Image.asset(
                                    "assets/coin.png",
                                    width: 32,
                                    height: 32,
                                    fit: BoxFit.cover,
                                  ),
                                  Text(formatNumber(user.coins!.toInt()),
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.normal)),
                                  Spacer(),
                                  Image.asset(
                                    "assets/logo.PNG",
                                    width: 32,
                                    height: 32,
                                    fit: BoxFit.cover,
                                  ),
                                  Text(user.hattricks.toString(),
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.normal)),
                                  Spacer(),
                                  Image.asset(
                                    "assets/xp.png",
                                    width: 32,
                                    height: 32,
                                    fit: BoxFit.cover,
                                  ),
                                  Text(
                                      formatNumber(auth
                                          .currentuser!.practice_points!
                                          .toInt()),
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.normal)),
                                  Spacer()
                                ],
                              )),
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
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: user.FullName.toString(),
                                    style: GoogleFonts.poppins(
                                      color: Color.fromARGB(176, 137, 153, 246),
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 22),
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 235,
                                padding: EdgeInsets.only(
                                    top: 19, bottom: 5, left: 25, right: 25),
                                decoration: ShapeDecoration(
                                  color: Color(0xFF141414),
                                  image: DecorationImage(
                                      image: AssetImage('assets/banner.png'),
                                      fit: BoxFit.cover),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  )),
                                ),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Hattrick Season ${leagues.last.id}",
                                        style: GoogleFonts.poppins(
                                            backgroundColor: Colors.black,
                                            fontSize: 24,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Ends ${_formatDate(leagues.last.ends)}",
                                        style: GoogleFonts.poppins(
                                            backgroundColor: Colors.white,
                                            fontSize: 6,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ]),
                              ),
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 130,
                                  padding: EdgeInsets.only(
                                      top: 19, bottom: 5, left: 25, right: 25),
                                  decoration: ShapeDecoration(
                                    color: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                    )),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            "assets/win.png",
                                            height: 30,
                                            width: 30,
                                          ),
                                          Text(
                                              "${formatNumber(leagues.last.prize)} NGN",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w700))
                                        ],
                                      ),
                                      SizedBox(height: 21),
                                      Row(children: [
                                        Text(
                                            "${formatNumber(leagues.last.players.length)} Players",
                                            style: GoogleFonts.poppins(
                                                color: Color(0xFFCACACA),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700)),
                                        Spacer(),
                                        GestureDetector(
                                          onTap: () async {
                                            if (user.is_subscribed &&
                                                leagues.last.players
                                                    .contains(user.uid)) {
                                              Navigator.push<void>(
                                                context,
                                                MaterialPageRoute<void>(
                                                  builder:
                                                      (BuildContext context) =>
                                                          QuizPage(
                                                    auth: widget.auth,
                                                    type: QuizType.Super_League,
                                                  ),
                                                ),
                                              );
                                            } else if (user.is_subscribed &&
                                                !leagues.last.players
                                                    .contains(user.uid)) {
                                              final response = await http.post(
                                                Uri.parse(
                                                    'https://hattrick-server-production.up.railway.app/join_league'),
                                                headers: <String, String>{
                                                  'Content-Type':
                                                      'application/json; charset=UTF-8',
                                                },
                                                body: jsonEncode(<String,
                                                    dynamic>{
                                                  'uid': user.uid.toString(),
                                                  'id': leagues.last.id,
                                                }),
                                              );

                                              print(response.body);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showMaterialBanner(
                                                MaterialBanner(
                                                  content:
                                                      Text('Subscribe First'),
                                                  actions: [
                                                    IconButton(
                                                      icon: Icon(Icons.close),
                                                      onPressed: () {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .hideCurrentMaterialBanner();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }
                                          },
                                          child: Container(
                                              width: 200,
                                              height: 45,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: Color(0xFF899AF6)),
                                              child: Center(
                                                child: Text(
                                                    leagues.last.players
                                                            .contains(
                                                                user.username)
                                                        ? "Play"
                                                        : "Join The League",
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.black,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                              )),
                                        )
                                      ])
                                    ],
                                  )),
                            ],
                          ),
                          SizedBox(height: 20),
                          Container(
                              width: 337,
                              height: 100,
                              padding: EdgeInsets.only(
                                  left: 39.0,
                                  right: 39.0,
                                  top: 15.0,
                                  bottom: 7.50),
                              decoration: BoxDecoration(
                                  color: Color(0xFF171717),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text("Hattrick Quiz",
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/win.png",
                                        height: 30,
                                        width: 30,
                                      ),
                                      Text("10,000 NGN",
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w800)),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () async {
                                          final response = await http.post(
                                            Uri.parse(
                                                "https://hattrick-server-production.up.railway.app//playable"),
                                            body: jsonEncode(<String, String>{
                                              'uid': user.uid.toString()
                                            }),
                                            headers: <String, String>{
                                              'Content-Type':
                                                  'application/json; charset=UTF-8',
                                            },
                                          );
                                          final data =
                                              jsonDecode(response.body);
                                          if (data['coins'] < 1) {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30)),
                                                    elevation: 0,
                                                    backgroundColor:
                                                        Colors.white,
                                                    content: Container(
                                                      width: 259,
                                                      height: 320,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Container(
                                                            width: 150,
                                                            height: 150,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100),
                                                                image: DecorationImage(
                                                                    image: AssetImage(
                                                                        "assets/cb.jpeg"))),
                                                          ),
                                                          Text("Out Of Coins",
                                                              style: GoogleFonts.poppins(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600)),
                                                          Text(
                                                            "Enough coins for today, see you tomorrow",
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    fontSize: 9,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('Close'),
                                                      ),
                                                    ],
                                                  );
                                                });
                                          } else {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute<void>(
                                                builder:
                                                    (BuildContext context) =>
                                                        new QuizPage(
                                                  auth: widget.auth,
                                                  type: QuizType.Practice_Play,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        child: Container(
                                            width: 120,
                                            height: 45,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: Color(0xFF899AF6)),
                                            child: Center(
                                              child: Text("Play",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w800)),
                                            )),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          SizedBox(height: 23),
                          SizedBox(width: 16),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }
            }),
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
