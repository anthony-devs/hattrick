import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hattrick/BuyCoins.dart';
import 'package:hattrick/CoinPacksPage.dart';
import 'package:hattrick/Models/user.dart';
//import 'package:hattrick/services/paystack_integration.dart';
import 'Models/user.dart';

class CoinPack {
  String name;
  int price;
  int coins;

  CoinPack({required this.coins, required this.price, required this.name});
}

class CoinPacks extends StatelessWidget {
  HattrickAuth auth;
  CoinPacks({super.key, required this.auth});
  List<CoinPack> packages = [
    CoinPack(coins: 11, price: 90000, name: "Pkg1"),
    CoinPack(coins: 20, price: 180000, name: "Pkg2"),
    CoinPack(coins: 25, price: 200000, name: "Pkg3"),
    CoinPack(coins: 30, price: 290000, name: "Pkg4"),
    CoinPack(coins: 50, price: 500000, name: "Pkg5"),
    CoinPack(coins: 99, price: 840000, name: "Pkg6")
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: Padding(
            padding: EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 0),
            child: ListView(children: [
              SizedBox(height: 72),
              Text("Buy Coins",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  )),
              SizedBox(height: 40),

              //...Card section
              Row(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width - 130,
                      height: 169,
                      padding: EdgeInsets.all(16),
                      decoration: ShapeDecoration(
                        color: Color(0x5B89E2F6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 24),
                            Text(
                              'You Have: ',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                            SizedBox(height: 30),
                            Text(
                              '${auth.currentuser!.coins} Coins Remaining',
                              style: GoogleFonts.poppins(
                                color: Colors.black.withOpacity(0.5),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                height: 0,
                              ),
                            )
                          ])),
                  Spacer(),
                  Container(
                    width: 63,
                    height: 169,
                    decoration: ShapeDecoration(
                      color: Color(0xA3DCC7FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  )
                ],
              ),

              SizedBox(height: 70),

              Padding(
                padding: const EdgeInsets.all(3.0),
                child: Wrap(
                  spacing: 60.0, // Adjust the spacing between items
                  runSpacing: 16.0, // Adjust the spacing between rows
                  alignment: WrapAlignment
                      .center, // Adjust the alignment within each row
                  children: packages.map((item) {
                    return GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext) {
                              return BuyCoins(auth: auth, pack: item);
                            });
                      },
                      child: Container(
                        width: 164,
                        height: 94,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: Color.fromARGB(73, 0, 0, 0),
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        child: Center(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${item.coins} Coins',
                                  style: GoogleFonts.poppins(
                                    color: Color(0xFF8C75BC),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    height: 0,
                                  ),
                                ),
                                Text(
                                  '\u20A6 ${item.price / 100}',
                                  style: GoogleFonts.poppins(
                                    color: Colors.black
                                        .withOpacity(0.3799999952316284),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    height: 0,
                                  ),
                                )
                              ]),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              SizedBox(height: 62),

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
              SizedBox(
                height: 25,
              )
            ])));
  }
}
