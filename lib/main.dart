import 'package:flutter/material.dart';
import 'package:hattrick/AuthPage.dart';
import 'package:hattrick/Homepage.dart';
import 'package:hattrick/Models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Pages/Quizpage.dart';
import 'Pages/login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Pages/quizupload.dart';
import 'dart:async';

import 'Pages/signup.dart';
//import 'firebase_options.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final auth = HattrickAuth();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hattrick',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.poppinsTextTheme()),
      home: const MyHomePage(title: 'Hattrick Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final auth = HattrickAuth();

  @override
  void initState() {
    super.initState();
  }

  Future<bool> checkUsername() async {
    final preferences = await SharedPreferences.getInstance();
    final uname = preferences.getString("username");
    return uname!.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return AuthPage();

    //return QuizUploader();
  }
}
