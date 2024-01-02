import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hattrick/AuthPage.dart';
import 'package:hattrick/Pages/Quizpage.dart';
import 'package:hattrick/VisitProfile.dart';
import 'package:hattrick/main.dart';
import 'package:intl/intl.dart';

import 'Homepage.dart';
import 'LeadHome.dart';
import 'Models/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({super.key});

  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  final auth = HattrickAuth();
  List<AUser> leads = [];
  Map<String, Future<Uint8List>> svgImages = {};

  @override
  void initState() {
    super.initState();
    auth.PasswordlessSignIn();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    dynamic response = await http.get(Uri.parse(
        'https://hattrick-server-production.up.railway.app//get-board'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      setState(() {
        leads = data.map((userJson) => AUser.fromJson(userJson)).toList();
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<Uint8List> loadSvgAsUint8List(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final rawData = response.body;
      final svgString = utf8.encode(rawData);
      return Uint8List.fromList(svgString);
    } else {
      throw Exception('Failed to load SVG');
    }
  }

  Widget getSvgImage(String city) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
          border: Border.all(),
          image: DecorationImage(
            image: NetworkImage(city),
          ),
          shape: BoxShape.circle),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (leads.isEmpty) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        body: ListView(
          children: [
            for (var user in leads)
              ListTile(
                tileColor: user.username == auth.currentuser!.username
                    ? Color(0xFF8C75BC)
                    : Colors.transparent,
                title: Text(user.username,
                    style: GoogleFonts.poppins(color: Colors.black)),
                onTap: () async {
                  final response = await http.post(
                    Uri.parse(
                        "https://hattrick-server-production.up.railway.app//userlytics"),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonEncode(<String, String>{
                      'username': user.username,
                    }),
                  );
                  final data = await jsonDecode(response.body);
                  final all_score =
                      data['super_points'] + data['practice_points'];
                  double percentage = data['percentage'];

                  await Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => VisitProfile(
                        userData: data,
                      ),
                    ),
                  );
                },
                subtitle: Text('Super Points: ${user.superPoints}'),
                trailing: Text("${leads.indexOf(user) + 1}"),
                leading: Container(
                  width: 20,
                  height: 20,
                  decoration: ShapeDecoration(
                    image: DecorationImage(
                      image: NetworkImage(user.city.toString()),
                      fit: BoxFit.cover,
                    ),
                    shape: OvalBorder(),
                  ),
                  //child: Image.network(flag.toString()),
                ),
              ),
          ],
        ),
      );
    }
  }
}
