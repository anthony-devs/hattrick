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
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: ListView(
          children: [
            //SizedBox(height: 71),
            Container(
                height: 600,
                padding: EdgeInsets.all(40),
                decoration: ShapeDecoration(
                  color: Color.fromARGB(108, 227, 215, 255),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30))),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("@${userData['username']}",
                        style: GoogleFonts.poppins(
                          color: Color(0xFFAF89F6),
                          fontSize: 12,
                          fontWeight: FontWeight.w200,
                          height: 0,
                        )),
                    SizedBox(height: 14),
                    Text("${userData["FullName"]}",
                        style: GoogleFonts.poppins(
                            color: Color(0xFF322653),
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            height: 0)),
                    SizedBox(height: 31),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: ShapeDecoration(
                        color: Colors.white,
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
                                    color: Color.fromARGB(98, 0, 0, 0),
                                    fontSize: 8.0))
                          ]),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              width: 122,
                              height: 40,
                              decoration: ShapeDecoration(
                                color: Colors.white.withOpacity(0.75),
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
                          Container(
                              width: 122,
                              height: 40,
                              decoration: ShapeDecoration(
                                color: Colors.white.withOpacity(0.75),
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
                              )),
                        ],
                      ),
                    ),
                  ],
                )),
            SizedBox(height: 62),
            Text("Total Points",
                style: GoogleFonts.poppins(
                  color: Color.fromARGB(145, 0, 0, 0),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                )),
            Text(all_score.toString(),
                style: GoogleFonts.poppins(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                )),
            SizedBox(height: 21),
            Text("Super League Points",
                style: GoogleFonts.poppins(
                  color: Color.fromARGB(145, 0, 0, 0),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                )),
            Text(userData["super_points"].toString(),
                style: GoogleFonts.poppins(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                )),
            SizedBox(height: 21),
            Text("User Analytics",
                style: GoogleFonts.poppins(
                  color: Color.fromARGB(145, 0, 0, 0),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                )),
            Text("Won ${percentage.toStringAsFixed(1)}% Of Games",
                style: GoogleFonts.poppins(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                )),

            Center(
              child: LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: Colors.grey[800],
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFAF89F6))),
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
                      color: Colors.black.withOpacity(0.23000000417232513),
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Close",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
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
