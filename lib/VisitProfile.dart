import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VisitProfile extends StatelessWidget {
  dynamic userData;
  VisitProfile({super.key, required this.userData});
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

  @override
  Widget build(BuildContext context) {
    final all_score = userData['super_points'] + userData['practice_points'];
    double percentage = userData['percentage'];
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: ListView(
          children: [
            SizedBox(height: 32),
            Container(
                height: 450,
                padding: EdgeInsets.all(40),
                decoration: ShapeDecoration(
                    color: Color(0xFFE3D7FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("${userData["FullName"]}",
                        overflow: TextOverflow.fade,
                        style: GoogleFonts.poppins(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        )),
                    SizedBox(height: 14),
                    Text("@${userData['username']}",
                        style: GoogleFonts.poppins(
                          color: Color(0xFFE3D7FF),
                          fontSize: 12,
                          fontWeight: FontWeight.w200,
                        )),
                    SizedBox(height: 31),
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Center(
                        child: Container(
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
                                  formatNumber(userData["played"]),
                                  textAlign: TextAlign.center,
                                ),
                                Text("Games Played",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        color: Color(0xFFE3D7FF),
                                        fontSize: 8.0))
                              ]),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                  "${formatNumber(userData["practice_points"])} - Practice Points",
                                  style: GoogleFonts.poppins(
                                    color: Color(0xFFC5ACFF),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                  )),
                            )),
                        //Spacer(),
                        SizedBox(width: 13),
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
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFAF89F6))),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total Points",
                          textAlign: TextAlign.left,
                          style: GoogleFonts.poppins(
                            color: Color(0x911D1D1D),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          )),
                      Text(formatNumber(all_score),
                          textAlign: TextAlign.left,
                          style: GoogleFonts.poppins(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          )),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Super League Points",
                          textAlign: TextAlign.right,
                          style: GoogleFonts.poppins(
                            color: Color(0x911D1D1D),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          )),
                      Text(formatNumber(userData["super_points"]),
                          textAlign: TextAlign.right,
                          style: GoogleFonts.poppins(
                            color: Color(0xFF000000),
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
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
                      fontWeight: FontWeight.w400,
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
