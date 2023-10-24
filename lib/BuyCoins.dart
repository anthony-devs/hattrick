import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hattrick/Models/user.dart';
import 'package:hattrick/services/paystack_integration.dart';

class BuyCoins extends StatefulWidget {
  final coins = TextEditingController();
  HattrickAuth auth;
  BuyCoins({super.key, required this.auth});

  @override
  State<BuyCoins> createState() => _BuyCoinsState();
}

class _BuyCoinsState extends State<BuyCoins> {
  final payStackClient = PaystackPlugin();

  void _startPaystack() async {
    payStackClient.initialize(
        publicKey: "pk_live_6ad9b26c3ba1dba6c7d16a945f8bb635370b9b7e");
  }

  @override
  void initState() {
    super.initState();
    _startPaystack();
  }

  String generateRef() {
    final randomCode = Random().nextInt(3234234);
    return 'ref-$randomCode-${widget.auth.currentuser!.uid}';
  }

  void _makePayment(price) async {
    await PaystackPopup.openPaystackPopup(
      email: widget.auth.currentuser!.email.toString(),
      amount: price.toString(),
      ref: generateRef(),
      onClosed: () {
        showInfo("Payment Failed", Colors.red);
      },
      onSuccess: () {
        showInfo("Payment Succesful", Colors.greenAccent);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: widget.coins,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'Enter a number',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 10),
                color: Colors.blueAccent,
                elevation: 15,
                child: Container(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Pay with Paystack",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.payment_rounded,
                          size: 30,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              onTap: () async {
                final String reference =
                    "unique_transaction_ref_${Random().nextInt(1000000)}";
                final coinsValue = widget.coins.text;
                if (coinsValue.isNotEmpty) {
                  final int theCoins = int.parse(coinsValue);
                  print(coinsValue);
                  if (theCoins != null) {
                    final int price = theCoins * 3000;
                    print(price);
                    print(" This is the Price: $price");
                    _makePayment(price);
                  } else {
                    // Handle the case where parsing fails
                    print("could Not Parse");
                    showInfo(
                        "A Severe Error Occured, Try Again Later", Colors.red);
                  }
                } else {
                  // Handle the case where coinsValue is empty
                  showInfo(
                      "Coins Cannot Be Blank", Color.fromARGB(44, 29, 29, 29));
                }
              }),
          SizedBox(height: 42),
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
          )
        ],
      ),
    );
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
