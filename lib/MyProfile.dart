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
import 'package:rive/rive.dart';
import 'package:rive_loading/rive_loading.dart';
import 'CoinPacksPage.dart';
import 'Homepage.dart';
import 'LeadHome.dart';
import 'Models/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final auth = HattrickAuth();
  bool isMounted = false;
  String? flag;

  @override
  void initState() {
    super.initState();
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
    final response = await http.post(
      Uri.parse("http://localhost:5000/userlytics"),
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

  @override
  Widget build(BuildContext context) {
    final user = auth.currentuser;
    final formatter = NumberFormat('#,###,###,###,###,###');
    print(flag);
    if (user != null) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(left: 47.0, right: 47.0),
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
                        Uri.parse("http://localhost:5000/userlytics"),
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
              user!.FullName.toString(),
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
                  color: Color(0xFFAF89F6),
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
                                      color: Color(0xFFAF89F6),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ))),
                          ),
                          SizedBox(height: 24),
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
                          Container(
                            width: 178,
                            child: Text(
                              "₦ ${formatter.format(auth.currentuser!.earning_balance)}",
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
            SizedBox(
              height: 105,
            )
          ]),
        ),
      );
    } else {
      return Scaffold(
          backgroundColor: Colors.black,
          body: Center(
              child: RiveAnimation.asset(
            'assets/load.riv',
          )));
    }
  }
}
