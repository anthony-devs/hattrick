import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Homepage.dart';
import 'Models/user.dart';
import 'login_or_register.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final auth = HattrickAuth();

  @override
  void initState() {
    super.initState();
    auth.PasswordlessSignIn().then((_) {
      setState(() {}); // Refresh the widget after sign-in.
    });

    print(auth.currentuser);
  }

  @override
  Widget build(BuildContext context) {
    if (auth.currentuser == null) {
      return LoginOrRegister();
    } else {
      print(auth.currentuser);
      return HomePage();
    }
  }
}
