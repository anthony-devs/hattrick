//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hattrick/AuthPage.dart';
import 'package:hattrick/Pages/signup.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

import '../Models/user.dart';

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
        child: const Text(
          'Register now',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor:
          isdarkMode ? Colors.white : Color.fromARGB(255, 40, 42, 57),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: [
            SizedBox(height: 40),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "Welcome\nBack",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                      color: isdarkMode
                          ? Color.fromARGB(255, 40, 42, 57)
                          : Colors.white,
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
            ),
            SizedBox(height: 26),
            // Password Input
            NeumorphicInputField(
              controller: password,
              hintText: "Password",
              isPassword: true,
              showPassword: showPassword,
              toggleShowPassword: toggleShowPassword,
              isdarkMode: isdarkMode,
            ),
            SizedBox(height: 86),
            Center(
              child: NeumorphicButton(
                onPressed: () {
                  auth.Login(email.text, password.text);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AuthPage()));
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
                  style: TextStyle(color: Colors.white),
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
      this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 335,
      height: 70,
      decoration: BoxDecoration(
        color: isdarkMode
            ? Color.fromARGB(255, 40, 42, 57)
            : Color.fromARGB(255, 53, 55, 70),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                obscureText: isPassword ? !showPassword : false,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(
                            borderColor!.value)), // Use the borderColor here
                  ),
                  hintStyle: GoogleFonts.poppins(
                    color: Color.fromARGB(153, 255, 255, 255),
                    fontWeight: FontWeight.w200,
                  ),
                ),
                style: GoogleFonts.poppins(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ),
            if (isPassword)
              IconButton(
                icon: Icon(
                  showPassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white,
                ),
                onPressed: toggleShowPassword,
              ),
          ],
        ),
      ),
    );
  }
}

class NeumorphicButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  bool isdarkMode;

  NeumorphicButton(
      {required this.onPressed, required this.text, required this.isdarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: isdarkMode ? Color.fromARGB(255, 40, 42, 57) : Color(0xFF801EF3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      width: 238,
      height: 50,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
