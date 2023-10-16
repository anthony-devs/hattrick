// ignore_for_file: file_names, prefer_const_constructors, use_build_context_synchronously
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hattrick/AuthPage.dart';
import 'package:hattrick/Pages/Quizpage.dart';
import 'package:hattrick/VisitProfile.dart';
import 'package:hattrick/main.dart';
import 'package:intl/intl.dart';
import 'package:rive/rive.dart';
import 'package:rive_loading/rive_loading.dart';
import 'LeadHome.dart';
import 'Models/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:flutter_paystack_plus/flutter_paystack_plus.dart';

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
    dynamic response =
        await http.get(Uri.parse('http://localhost:5000/get-three'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        leads = data.map((userJson) => AUser.fromJson(userJson)).toList();
      });
    } else {
      throw Exception('Failed to load users');
    }

    while (true) {
      sleep(Duration(seconds: 15));
      this.fetchUsers();
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
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 12,
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
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 12,
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
      //print(auth.currentuser!.coins);
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
                            text: auth.currentuser!.FullName.toString(),
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
                    ),
                  )
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
                  Text(
                    "Coins",
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(width: 15),
                  Text(
                    "${formatter.format(
                      auth.currentuser!.coins,
                    )}",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 16,
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
                      //...(Buy Coins)...
                      //FlutterPaystackPlus.openPaystackPopup(customerEmail: auth.currentuser!.email.toString(), amount: amount, reference: reference, onClosed: onClosed, onSuccess: onSuccess)
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            final coins = TextEditingController();
                            int price = 0;
                            return AlertDialog(
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              content: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 10.0,
                                  sigmaY: 10.0,
                                ),
                                child: Container(
                                  height: 248,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Color.fromARGB(0, 255, 255, 255)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextFormField(
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        decoration: InputDecoration(
                                          labelText: 'Enter a number',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      GestureDetector(
                                          child: Container(
                                            width: 98.88,
                                            height: 28,
                                            decoration: ShapeDecoration(
                                              color: Color(0xFFAF89F6),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Proceed To Pay',
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
                                          onTap: () async {
                                            setState(() {
                                              price =
                                                  int.parse(coins.text) * 10;
                                            });
                                            await FlutterPaystackPlus
                                                .openPaystackPopup(
                                                    customerEmail: auth
                                                        .currentuser!.email
                                                        .toString(),
                                                    amount: price.toString(),
                                                    reference: "Coins Bought",
                                                    onClosed: () {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showMaterialBanner(
                                                        MaterialBanner(
                                                          content: Text(
                                                              "You Didn't Complete Payment"),
                                                          actions: [
                                                            IconButton(
                                                              icon: Icon(
                                                                  Icons.close),
                                                              onPressed: () {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .hideCurrentMaterialBanner();
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                    onSuccess: () async {
                                                      final response =
                                                          await http.post(
                                                        Uri.parse(
                                                            "localhost:5000/buy-coins"),
                                                        body: jsonEncode(<
                                                            String, String>{
                                                          "uid": auth
                                                              .currentuser!.uid
                                                              .toString(),
                                                          "amt": coins.text
                                                        }),
                                                        headers: <String,
                                                            String>{
                                                          'Content-Type':
                                                              'application/json; charset=UTF-8',
                                                        },
                                                      );

                                                      if (response.statusCode ==
                                                          200) {
                                                        showInfo(
                                                            "Succesfully Bought ${coins.text} Coins",
                                                            Colors.greenAccent);
                                                      } else {
                                                        showInfo(
                                                            "Could Not Finish Purchase, Try Again Later",
                                                            Colors.deepOrange);
                                                      }
                                                    });
                                          })
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                  ),
                ],
              ),
              SizedBox(height: 23),
              Row(
                children: [
                  //Card
                  SizedBox(height: 18.93),
                  Container(
                    width: MediaQuery.of(context).size.width - 60,
                    padding: EdgeInsets.all(12),
                    decoration: ShapeDecoration(
                      color: Color(0xFFE3D7FF),
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
                              Center(
                                child: SizedBox(
                                    width: 178,
                                    height: 43.27,
                                    child: Text('Get Verified To Start Earning',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          color: Color(0xFF8C75BC),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ))),
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
                              Text(
                                'Earnings',
                                style: GoogleFonts.poppins(
                                  color: Color(0xFF8C75BC),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300,
                                  height: 0,
                                ),
                              ),
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
                                  ),
                                ),
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
                                  ),
                                ),
                                onTap: () {
                                  //...(Withdraw)...
                                  showInfo("I'm Just Testing Bro",
                                      Colors.greenAccent);
                                },
                              ),
                            ],
                    ),
                  ),
                  SizedBox(width: 16),
                ],
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  if (auth.currentuser!.coins! < 1) {
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
                        builder: (BuildContext context) => new QuizPage(),
                      ),
                    );
                  }
                },
                child: Container(
                    width: 150,
                    height: 47,
                    decoration: ShapeDecoration(
                      color: Color(0x9EFFDFB0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Center(
                      child: Text("New Quiz",
                          style: GoogleFonts.poppins(
                            color: Color(0xFFEA8843),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          )),
                    )),
              ),
              SizedBox(height: 30),
              //Leaderboards!!!
              Text(
                'Leaderboard',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),
              SizedBox(height: 12),

              Container(
                width: MediaQuery.of(context).size.width - 60,
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
                      for (var user in leads)
                        ListTile(
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
                            final all_score =
                                data['super_points'] + data['practice_points'];
                            double percentage = data['percentage'];
                            Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) => VisitProfile(
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
          backgroundColor: Color(0xFF1D1D1D),
          body: Center(
              child: RiveAnimation.asset(
            'assets/load.riv',
          )));
    }
  }

  void showInfo(err, Color color) {
    setState(() {
      Fluttertoast.showToast(
          timeInSecForIosWeb: 4,
          gravity: ToastGravity.BOTTOM,
          webPosition: "center",
          webBgColor: color.value.toString(),
          msg: err.toString(),
          textColor: Colors.white,
          backgroundColor: color,
          fontSize: 16.0);
    });
  }
}
