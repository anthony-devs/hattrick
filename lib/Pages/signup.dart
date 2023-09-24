import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hattrick/AuthPage.dart';
import 'package:hattrick/main.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:rive/components.dart';
import 'package:rive/rive.dart';
import '../Models/user.dart';
import 'login.dart';
import 'package:hattrick/Components/city_service.dart';
//import 'package:firebase_auth/firebase_auth.dart';

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

    List<String> countries = [];
    List<String> cities = [];
    String selectedCountry = 'Select a Country';
    String? selectedCity;
    Future<void> _loadCountries() async {
      final loadedCountries = await CityService.getCountries();
      setState(() {
        countries = loadedCountries;
      });
    }

    // Create a new Firestore document for the user

    @override
    void initState() {
      super.initState();
      _loadCountries();
    }

    Color usernameBorderColor = Colors.grey; // Default border color
    Color emailBorderColor = Colors.grey; // Default border color

    Future<void> signUserUp() async {
      showDialog(
          context: context,
          builder: (context) {
            return Center(
              child: RiveAnimation.asset(
                'assets/load.riv',
              ),
            );
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
            //Navigator.push(
            //  context, MaterialPageRoute(builder: (context) => AuthPage()));
            //runApp(MyApp());
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

    Future<void> _loadCitiesByCountry(String country) async {
      final loadedCities = await CityService.getCitiesByCountry(country);
      setState(() {
        cities = loadedCities;
        selectedCity = 'Select a City';
      });
    }

    void _onCountryChanged(String? country) {
      if (country != null) {
        setState(() {
          selectedCountry = country;
          _loadCitiesByCountry(country);
        });
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
        context: context,
        backgroundColor: Colors.transparent,
        //isDismissible: false,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 10.0,
              sigmaY: 10.0,
            ), // Adjust blur intensity
            child: Container(
              //height: double.infinity, // Define the height here
              decoration: ShapeDecoration(
                color: Color(0x598478F9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CountryInputWidget(
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
                  ],
                ),
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
      Fluttertoast.showToast(
          msg: err.toString(),
          textColor: Colors.white,
          backgroundColor: Colors.deepOrange,
          fontSize: 16.0);
    });
  }
}
