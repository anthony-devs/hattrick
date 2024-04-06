import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'login_or_register.dart';
import 'Home.dart';
import 'Models/user.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late Timer _timer;
  final auth = HattrickAuth();
  bool _isLoading = true;
  String? uid = "";
  late Future<User?> _user;

  Future<User?> userFuture() async {
    User? user = auth.currentuser;
    return user;
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
    _user = userFuture();
  }

  Future<void> _startTimer() async {
    await Future.delayed(Duration(seconds: 2)); // Wait for 2 seconds
    final preferences = await SharedPreferences.getInstance();
    final uname = preferences.getString("username");
    if (uname != null && uname.isNotEmpty) {
      await auth.PasswordlessSignIn();
      if (auth.currentuser != null) {
        setState(() {
          _isLoading = false;
          uid = uname;
        });
      }
    } else {
      setState(() {
        _isLoading = false; // Set isLoading to false if username is not found
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
            body: uid!.isEmpty && auth.currentuser == null
                ? LoginOrRegister(auth: auth)
                : Home(auth: auth));
  }
}
