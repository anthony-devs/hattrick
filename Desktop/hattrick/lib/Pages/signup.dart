import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hattrick/AuthPage.dart';
import 'package:hattrick/main.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
//import 'package:rive/components.dart';
import '../Models/user.dart';
import 'login.dart';
import 'package:hattrick/Components/city_service.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class Signup extends StatefulWidget {
  Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool showPassword = false;

  final email = TextEditingController();

  final password = TextEditingController();

  final Confirmedpassword = TextEditingController();

  final username = TextEditingController();

  final fullName = TextEditingController();

  String? city;
  bool isValid = false;

  bool isdarkMode = false;
  String error = "";
  final auth = HattrickAuth();
  List<String> stringCountries = [
    "Nigeria",
    "Ghana",
    "Niger",
    "South Africa",
    "Botswana",
    "United States",
    "Canada",
    "England",
    "Israel",
    "Egypt",
    "Germany",
    "benin",
    "Togo",
    "Gambia",
    "Senegal",
    "Angola",
    "Tunisia"
  ];
  List<Map<String, dynamic>> countries = [];
  Future<void> fetchCountries() async {
    for (var i in stringCountries) {
      try {
        final response = await http
            .get(Uri.parse("https://restcountries.com/v3.1/name/${i}"));

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);

          // Check if the response contains data
          if (data.isNotEmpty) {
            final countryData = data[0]; // Access the first element

            countries.add({
              'name': countryData['name']['common'],
              'flag': countryData['flags']['png'],
            });
          } else {
            throw Exception('No data for country $i');
          }
        } else {
          throw Exception('Failed to load country $i');
        }
      } catch (e) {
        // TODO
        print('Failed to load country $i');
      }
    }
  }

  //List<String> cities = [];
  String selectedCountry = 'Select a Country';
  String? selectedCity;

  @override
  void initState() {
    super.initState();
    fetchCountries();
  }

  @override
  Widget build(BuildContext context) {
    Widget regNow() {
      return GestureDetector(
        onTap: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Login()), // Navigate to Login page
          );
        },
        child: const Text(
          'Login',
          style: TextStyle(
            color: Color(0xFF322653),
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    Color usernameBorderColor = Colors.grey; // Default border color
    Color emailBorderColor = Colors.grey; // Default border color

    Future<void> signUserUp() async {
      showDialog(
          context: context,
          builder: (context) {
            return Center(child: CircularProgressIndicator());
          });
      if (fullName.text.isEmpty) {
        isValid = false;
      } else if (password.text.isEmpty) {
        isValid = false;
      } else if (password.text != Confirmedpassword.text) {
        isValid = false;
      } else if (email.text.contains('@') == false) {
        isValid = false;
      } else {
        isValid = true;
      }

      if (isValid) {
        try {
          final response = await auth.RegisterUser(
            city: city,
            username: username.text,
            full_name: fullName.text,
            email: email.text,
            password: password.text,
          );
          final code = response.statusCode;
          final data = json.decode(response.body);
          print(code);
          if (code == 200) {
            await auth.PasswordlessSignIn();
            await Navigator.push(
                context, MaterialPageRoute(builder: (context) => AuthPage()));
            //await runApp(MyApp());
            print(code);
          } else if (code == 404) {
            Fluttertoast.showToast(
                msg: data['error'],
                textColor: Colors.white,
                backgroundColor: Colors.deepOrange,
                fontSize: 16.0);
          } else if (code == 92) {
            Fluttertoast.showToast(
                msg: data['error'],
                textColor: Colors.white,
                backgroundColor: Colors.deepOrange,
                fontSize: 16.0);
          } else if (code == 500) {
            Fluttertoast.showToast(
                msg: "An Internal Server Error Occured",
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
        } catch (e) {
          // Handle other errors
          print(e);
          Navigator.pop(context);
        }
      } else {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('Put In the Appropriate Information'),
              );
            });
        print(auth.currentuser);
      }
    }

    void _onCityChanged(String? city) {
      if (city != null) {
        setState(() {
          selectedCity = city;
        });
      }
    }

    String err = "";
    void showADialog(text) {
      //showDialog(
      //context: context,
      //builder: (BuildContext context) {

      //return Center(
      //child: AlertDialog(
      //icon: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.close)),
      //title: Text(text),
      //elevation: 0,
      // shadowColor: Colors.transparent,
      // ),
      // );
      // });

      setError(text);
    }

    void onContinue() async {
      showModalBottomSheet(
        elevation: 0,
        context: context,
        backgroundColor: Colors.transparent,
        //isDismissible: false,
        builder: (context) {
          return Container(
            height: 490, // Define the height here
            decoration: ShapeDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(0), topRight: Radius.circular(0)),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  CountryInputWidget(
                    countries: countries,
                    onCountrySelected: (selectedCountry) {
                      // Update the value of the external widget here
                      setState(() {
                        city = selectedCountry;
                      });
                    },
                  ),
                  SizedBox(
                    height: 21,
                  ),
                  NeumorphicInputField(
                    spaces: true,
                    controller: this.fullName,
                    hintText: "Full Name",
                    toggleShowPassword: toggleShowPassword,
                    isdarkMode: isdarkMode,
                    isPassword: false,
                    borderColor: Colors.transparent,
                    TheIcon: Icons.text_fields,
                  ),
                  SizedBox(
                    height: 21,
                  ),
                  NeumorphicInputField(
                    spaces: false,
                    controller: this.username,
                    hintText: "Username",
                    toggleShowPassword: toggleShowPassword,
                    borderColor: emailBorderColor,
                    isdarkMode: isdarkMode,
                    isPassword: false,
                    TheIcon: Icons.person,
                  ),
                  SizedBox(height: 10),
                  NeumorphicButton(
                    onPressed: () {
                      signUserUp();
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AuthPage(),
                        ),
                      );
                    },
                    text: "Sign Up",
                    isdarkMode: isdarkMode,
                  ),
                  SizedBox(height: 15)
                ],
              ),
            ),
          );
        },
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
                    "Create a new \nAccount",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 36,
                      color: Colors.black,
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
              borderColor: emailBorderColor,
              TheIcon: Icons.email, // Set border color
            ),
            SizedBox(height: 36),
            // Password Input
            NeumorphicInputField(
              spaces: false,
              controller: password,
              hintText: "Password",
              isPassword: true,
              showPassword: showPassword,
              toggleShowPassword: toggleShowPassword,
              isdarkMode: isdarkMode,
              borderColor: Colors.transparent,
              TheIcon: Icons.password,
            ),
            SizedBox(height: 21),
            // Password Input
            NeumorphicInputField(
              spaces: false,
              controller: Confirmedpassword,
              hintText: "Confirm Password",
              isPassword: true,
              showPassword: showPassword,
              toggleShowPassword: toggleShowPassword,
              isdarkMode: isdarkMode,
              borderColor: Colors.transparent,
              TheIcon: Icons.password,
            ),
            //Text(error, style: GoogleFonts.poppins(color: Colors.redAccent)),
            SizedBox(height: 86),
            Center(
              child: NeumorphicButton(
                onPressed: () {
                  if (Confirmedpassword.text != password.text) {
                    showADialog("Passwords Don't Match");
                    print(error);
                  } else if (Confirmedpassword.text.isEmpty) {
                    showADialog("Put The Appropriate Info");
                  } else {
                    onContinue();
                  }
                },
                text: "Continue",
                isdarkMode: isdarkMode,
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already a member?',
                  style: TextStyle(color: Colors.black),
                ),
                SizedBox(width: 4),
                regNow(),
              ],
            ),

            SizedBox(height: 15)
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

  void setError(err) {
    setState(() {
      Color color = Colors.deepOrange;
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
