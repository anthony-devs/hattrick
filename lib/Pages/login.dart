//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hattrick/AuthPage.dart';
import 'package:hattrick/Home.dart';
import 'package:hattrick/Homepage.dart';
import 'package:hattrick/Pages/signup.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/user.dart';
import 'package:hattrick/main.dart';

class Login extends StatefulWidget {
  HattrickAuth auth;
  Login({super.key, required this.auth});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool showPassword = true;
  final email = TextEditingController();
  final password = TextEditingController();
  bool isdarkMode = false;

  @override
  Widget build(BuildContext context) {
    final auth = widget.auth;
    Widget regNow() {
      return GestureDetector(
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Signup(
                      auth: auth,
                    )),
            // Navigate to Login page
          );
        },
        child: Text(
          'Register now',
          style: TextStyle(
            color: Color(0xFF322653),
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            SizedBox(height: 137),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "Welcome\nBack",
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 36,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
            SizedBox(height: 36),
            // Email Input
            NeumorphicInputField(
                spaces: false,
                controller: email,
                hintText: "Email",
                toggleShowPassword: toggleShowPassword,
                isdarkMode: isdarkMode,
                TheIcon: Icons.email),
            SizedBox(height: 26),
            // Password Input
            NeumorphicInputField(
              spaces: false,
              controller: password,
              hintText: "Password",
              isPassword: true,
              showPassword: showPassword,
              toggleShowPassword: toggleShowPassword,
              isdarkMode: isdarkMode,
              TheIcon: Icons.password,
            ),
            SizedBox(height: 86),
            Center(
              child: NeumorphicButton(
                onPressed: () async {
                  final code = await auth.Login(email.text, password.text);
                  if (code == 200) {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Home(
                                auth: auth,
                              )),
                    );
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          elevation: 0,
                          backgroundColor: Colors.white,
                          content: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            width: 259,
                            height: 320,
                            child: Center(
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      image: DecorationImage(
                                        image: AssetImage(
                                            "assets/assets/welcome.jpeg"),
                                      ),
                                    ),
                                    width: 150,
                                    height: 150,
                                  ),
                                  Text(
                                    "Welcome Back",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    "Logged in as user @${auth.currentuser!.username}",
                                    style: GoogleFonts.poppins(
                                      color: Color(0xFF2F2F2F),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 9,
                                    ),
                                  ),
                                  SizedBox(height: 17),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push<void>(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              Home(auth: auth),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      child: Center(
                                        child: Text(
                                          "Continue To Home",
                                          style: GoogleFonts.poppins(
                                            color: Color(0xFFFFFFFF),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      width: 160,
                                      height: 33.61,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF9063E1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                    Fluttertoast.showToast(
                        msg: "Logged In",
                        textColor: Colors.white,
                        backgroundColor: Colors.deepOrange,
                        fontSize: 16.0);
                  } else {
                    String message;
                    if (code == 404) {
                      message = "Unknown User, Please Create an Account";
                    } else if (code == 500) {
                      message = "An Error Occurred";
                    } else if (code == 508) {
                      message = "Invalid Password";
                    } else {
                      message = "Please Check your Network and Try again later";
                    }
                    Fluttertoast.showToast(
                      msg: message,
                      textColor: Colors.white,
                      backgroundColor: Colors.deepOrange,
                      fontSize: 16.0,
                    );
                  }
                },
                text: "Log In",
                isdarkMode: isdarkMode,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Not a member?',
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(width: 4),
                regNow(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void toggleShowPassword() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  void toggleDarkMode() {
    setState(() {
      isdarkMode = !isdarkMode;
    });
  }
}

class NeumorphicInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final bool showPassword;
  final bool spaces;
  final IconData TheIcon;
  bool isdarkMode;
  final Color? borderColor;
  final Function() toggleShowPassword;

  NeumorphicInputField(
      {required this.controller,
      required this.hintText,
      this.isPassword = false,
      this.showPassword = false,
      required this.toggleShowPassword,
      required this.isdarkMode,
      this.borderColor,
      required this.spaces,
      required this.TheIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Color(0xFF353746)),
        width: double.infinity, // Changed from fixed width to fill the parent
        padding: EdgeInsets.all(10), // Added padding to the container
        child: TextField(
          inputFormatters: spaces
              ? []
              : [
                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                ],
          controller: controller,
          style: GoogleFonts.poppins(color: Colors.white),
          obscureText:
              isPassword && !showPassword, // Added to handle password fields
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            labelText: hintText,
            labelStyle: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            hintStyle: GoogleFonts.poppins(
                color: Colors.white), // Moved hintText to TextField
            //focusColor: Colors.transparent,
          ),
        ));
  }
}

class Country {
  final String name;
  final String flag;

  Country({required this.name, required this.flag});
}

class NeumorphicButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  bool isdarkMode;

  NeumorphicButton(
      {required this.onPressed, required this.text, required this.isdarkMode});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
          width: 238,
          height: 50,
          decoration: ShapeDecoration(
            color: Color(0x5B89E2F6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Center(
            child: Text(this.text,
                style: GoogleFonts.poppins(
                  color: Color(0xFF322653),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                )),
          ),
        ));
  }
}

class CountryInputWidget extends StatefulWidget {
  final Function(String?) onCountrySelected;
  List<Map<String, dynamic>> countries = [];
  CountryInputWidget(
      {required this.onCountrySelected, required this.countries});

  @override
  _CountryInputWidgetState createState() => _CountryInputWidgetState();
}

class _CountryInputWidgetState extends State<CountryInputWidget> {
  List<String> stringCountries = [
    "Nigeria",
    "Ghana",
    "Niger",
    "RSA",
    "Botswana",
    "USA",
    "Canada",
    "GB",
    "Israel",
    "Egypt",
    "Germany",
    "Benin",
    "Togo",
    "Gambia",
    "Senegal",
    "Angola",
    "Tunisia"
  ];
  String? selectedCountry;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 12,
      child: Column(
        children: [
          DropdownButton<String>(
            hint: Text("Select A Country"),
            value: selectedCountry,
            onChanged: (String? newValue) {
              setState(() {
                selectedCountry = newValue;
                widget.onCountrySelected(newValue);
              });
            },
            items: [
              DropdownMenuItem<String>(
                value: "Select One",
                child: Text("Select One"),
              ),
              for (Map<String, dynamic> country in widget.countries)
                DropdownMenuItem<String>(
                  value: country['name']
                      .toString()
                      .replaceAll("Outlying Islands", ""),
                  child: Container(
                    width: 210,
                    child: Row(
                      children: [
                        Image.network(
                          country['flag'],
                          width: 20,
                          height: 10,
                        ),
                        SizedBox(width: 5),
                        Text(
                          country['name']!
                              .toString()
                              .replaceAll("Outlying Islands", ""),
                          maxLines: 3,
                          overflow: TextOverflow.fade,
                          style: GoogleFonts.poppins(),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
