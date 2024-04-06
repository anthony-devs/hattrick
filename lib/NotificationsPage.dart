import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart' as http;
import 'Homepage.dart';
import 'Models/user.dart';

class Notifications extends StatefulWidget {
  HattrickAuth auth;
  Notifications({super.key, required this.auth});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  List<News> news = [];
  bool isMounted = false;

  @override
  void initState() {
    super.initState();
    isMounted = true; // Set isMounted to true when the widget is mounted

    //_startPaystack();
    getNews();
  }

  Future<void> getNews() async {
    dynamic response = await http.get(
        Uri.parse('https://hattrick-server-production.up.railway.app/news'));

    if (isMounted) {
      // Check if the widget is still mounted
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          news = data.map((newsJson) => News.fromJson(newsJson)).toList();
        });
      } else {
        throw Exception('Failed to load news');
      }
    }
    //while (true) {
    //sleep(Duration(seconds: 15));
    //fetchUsers();
    //}
  }

  @override
  Widget build(BuildContext context) {
    final auth = widget.auth;
    return Scaffold(
      backgroundColor: Color(0xFF0B0B0B),
      appBar: AppBar(
          elevation: 0,
          title: Text("Notifications"),
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(CupertinoIcons.back))),
      body: Center(
        child: ListView(
          children: [
            for (var i in news)
              Text(
                i.text ?? "Text",
                style: GoogleFonts.poppins(color: Colors.white),
              )
          ],
        ),
      ),
    );
  }
}
