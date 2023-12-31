import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VisitProfile extends StatelessWidget {
  dynamic userData;
  VisitProfile({super.key, required this.userData});

  @override
  Widget build(BuildContext context) {
    final all_score = userData['super_points'] + userData['practice_points'];
    double percentage = userData['percentage'];
    return Scaffold(
      backgroundColor: Color(0xFF0B0B0B),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: ListView(
          children: [
            SizedBox(height: 32),
            Container(
                height: 600,
                padding: EdgeInsets.all(40),
                decoration: ShapeDecoration(
                    color: Color.fromARGB(108, 215, 217, 255),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    )),
                child: ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${userData["FullName"]}",
                            overflow: TextOverflow.fade,
                            style: GoogleFonts.poppins(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            )),
                        SizedBox(height: 14),
                        Text("@${userData['username']}",
                            style: GoogleFonts.poppins(
                              color: Color(0xFF89E2F6),
                              fontSize: 12,
                              fontWeight: FontWeight.w200,
                            )),
                      ],
                    ),
                    SizedBox(height: 31),
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: ShapeDecoration(
                            color: Color(0xFF141414),
                            shape: OvalBorder(),
                            shadows: [
                              BoxShadow(
                                color: Color(0x66AF89F6),
                                blurRadius: 54,
                                offset: Offset(10, 10),
                                spreadRadius: 2,
                              )
                            ],
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  userData["played"].toString(),
                                  textAlign: TextAlign.center,
                                ),
                                Text("Games Played",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        color:
                                            Color.fromARGB(98, 255, 255, 255),
                                        fontSize: 8.0))
                              ]),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Column(
                      children: [
                        Container(
                            width: 122,
                            height: 40,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                  "${userData["practice_points"]} - Practice Points",
                                  style: GoogleFonts.poppins(
                                    color: Color(0xFFC5ACFF),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                  )),
                            )),
                        //Spacer(),
                        SizedBox(height: 13),
                        Container(
                            width: 122,
                            height: 40,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                  "${percentage.toStringAsFixed(2)}% Accuracy",
                                  style: GoogleFonts.poppins(
                                    color: Color(0xFFC5ACFF),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ))
                      ],
                    ),
                  ],
                )),
            SizedBox(height: 26),
            Center(
              child: LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: Colors.grey[800],
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF89E2F6))),
            ),
            Row(
              children: [
                Container(
                  child: Column(
                    children: [
                      Text("Total Points",
                          style: GoogleFonts.poppins(
                            color: Color.fromARGB(145, 255, 255, 255),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          )),
                      Text(all_score.toString(),
                          style: GoogleFonts.poppins(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          )),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  child: Column(
                    children: [
                      Text("Super League Points",
                          style: GoogleFonts.poppins(
                            color: Color.fromARGB(145, 255, 255, 255),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          )),
                      Text(userData["super_points"].toString(),
                          style: GoogleFonts.poppins(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          )),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 45),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Center(
                  child: Container(
                width: 122,
                height: 40,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: Colors.white.withOpacity(0.23000000417232513),
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Close",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )),
            ),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
