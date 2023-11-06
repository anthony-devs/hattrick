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
import 'package:rive/rive.dart';
import 'package:rive_loading/rive_loading.dart';
import 'Homepage.dart';
import 'LeadHome.dart';
import 'Models/user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

class LeaderBoardBeta extends StatefulWidget {
  const LeaderBoardBeta({super.key});

  @override
  State<LeaderBoardBeta> createState() => _LeaderBoardBetaState();
}

class _LeaderBoardBetaState extends State<LeaderBoardBeta> {
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
    dynamic response =
        await http.get(Uri.parse('http://localhost:5000/get-board'));

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
    if (!svgImages.containsKey(city)) {
      svgImages[city] = loadSvgAsUint8List(city);
    }
    return FutureBuilder<Uint8List>(
      future: svgImages[city],
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Container(
            width: 50,
            height: 50,
            decoration: ShapeDecoration(
              image: DecorationImage(
                image: MemoryImage(snapshot.data!),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // Loading indicator
        } else {
          return Icon(Icons.error); // Handle the error case
        }
      },
    );
  }

  Widget build(BuildContext context) {
    if (leads.isEmpty) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "Leaderboards",
            style: GoogleFonts.poppins(color: Colors.black),
          ),
        ),
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
                    Uri.parse("http://localhost:5000/userlytics"),
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
