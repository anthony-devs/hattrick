//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hattrick/AuthPage.dart';
import 'package:hattrick/Pages/signup.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/user.dart';
import 'package:hattrick/main.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool showPassword = true;
  final email = TextEditingController();
  final password = TextEditingController();
  bool isdarkMode = false;
  final auth = HattrickAuth();

  @override
  Widget build(BuildContext context) {
    Widget regNow() {
      return GestureDetector(
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Signup()),
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
                controller: email,
                hintText: "Email",
                toggleShowPassword: toggleShowPassword,
                isdarkMode: isdarkMode,
                TheIcon: Icons.email),
            SizedBox(height: 26),
            // Password Input
            NeumorphicInputField(
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyApp()));
                    Fluttertoast.showToast(
                        msg: "Logged In",
                        textColor: Colors.white,
                        backgroundColor: Colors.deepOrange,
                        fontSize: 16.0);
                    // runApp(MyApp());
                  } else if (code == 404) {
                    Fluttertoast.showToast(
                        msg: "Unknown User, Please Create an Account",
                        textColor: Colors.white,
                        backgroundColor: Colors.deepOrange,
                        fontSize: 16.0);
                  } else if (code == 500) {
                    Fluttertoast.showToast(
                        msg: "An Error Occured",
                        textColor: Colors.white,
                        backgroundColor: Colors.deepOrange,
                        fontSize: 16.0);
                  } else if (code == 508) {
                    Fluttertoast.showToast(
                        msg: "Invalid Password",
                        textColor: Colors.white,
                        backgroundColor: Colors.deepOrange,
                        fontSize: 16.0);
                  } else {
                    Fluttertoast.showToast(
                        msg: "Please Check your Network and Try again later",
                        textColor: Colors.white,
                        backgroundColor: Colors.deepOrange,
                        fontSize: 16.0);
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
      required this.TheIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Color(0xFF353746)),
        width: double.infinity, // Changed from fixed width to fill the parent
        padding: EdgeInsets.all(10), // Added padding to the container
        child: TextField(
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
            color: Color(0xFFAF89F6),
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
  final Function(String?) onCountrySelected; // Callback function

  CountryInputWidget({required this.onCountrySelected});

  @override
  _CountryInputWidgetState createState() => _CountryInputWidgetState();
}

class _CountryInputWidgetState extends State<CountryInputWidget> {
  List<Country> countries = [];
  String? selectedCountry; // Initialize as null to represent no selection

  @override
  void initState() {
    super.initState();
    fetchCountries();
  }

  Future<void> fetchCountries() async {
    final response =
        await http.get(Uri.parse('https://restcountries.com/v3.1/all'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        countries = data
            .map((countryData) => Country(
                  name: countryData['name']['common'],
                  flag: countryData['flags']['png'],
                ))
            .toList();
      });
    } else {
      throw Exception('Failed to load countries');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 12,
      child: Column(
        children: [
          DropdownButton<String>(
            hint: Text("Please Select A Country"),
            value: selectedCountry,
            onChanged: (String? newValue) {
              setState(() {
                selectedCountry = newValue; // Update selectedCountry
                widget
                    .onCountrySelected(newValue); // Call the callback function
              });
            },
            items: [
              DropdownMenuItem<String>(
                value: "Select One", // Add a default value
                child: Text("Select One"),
              ),
              for (Country country in countries)
                DropdownMenuItem<String>(
                  value: country.name,
                  child: Container(
                    child: Row(
                      children: [
                        Image.network(
                          country.flag,
                          width: 30,
                          height: 20,
                        ),
                        SizedBox(width: 10),
                        Text(country.name),
                      ],
                    ),
                  ),
                ),
            ],
          ), // Display the selected country or "No country selected" if null
        ],
      ),
    );
  }
}
