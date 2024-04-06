import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'Homepage.dart';
import 'Models/user.dart';

class LeaderBoard extends StatefulWidget {
  final HattrickAuth auth;

  LeaderBoard({Key? key, required this.auth}) : super(key: key);

  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String xpUrl = 'https://flagcdn.com/w320/ng.png';
  String sUrl = 'https://flagcdn.com/w320/ng.png'; // Default flag URL

  late Future<List<AUser>> _fetchUsersFuture;
  late Future<List<AUser>> _fetchSuperUsersFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchUsersFuture = fetchUsers();
    _fetchSuperUsersFuture = fetchSuperUsers();
  }

  Future<List<AUser>> fetchUsers() async {
    final response = await http.get(
        Uri.parse('https://hattrick-server-production.up.railway.app//get-xp'));

    if (response.statusCode == 200) {
      final List<dynamic>? data = json.decode(response.body);

      return (data ?? [])
          .map((userJson) => AUser.fromJson(replaceNullsWithZero(userJson)))
          .toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<List<AUser>> fetchSuperUsers() async {
    final response = await http.get(Uri.parse(
        'https://hattrick-server-production.up.railway.app//get-super'));

    if (response.statusCode == 200) {
      final List<dynamic>? data = json.decode(response.body);
      return (data ?? [])
          .map((userJson) => AUser.fromJson(replaceNullsWithZero(userJson)))
          .toList();
    } else {
      throw Exception('Failed to load super users');
    }
  }

  Future<void> fetchCountryFlag(String xpc) async {
    try {
      final response =
          await http.get(Uri.parse('https://restcountries.com/v3.1/name/$xpc'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        final String flagUrl = data[0]['flags']['png'];
        setState(() {
          xpUrl = flagUrl;
        });
      } else {
        print('Failed to fetch country data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching country data: $e');
    }
  }

  Future<void> fetchSflag(String spc) async {
    try {
      final response =
          await http.get(Uri.parse('https://restcountries.com/v3.1/name/$spc'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        final String flagUrl = data[0]['flags']['png'];
        setState(() {
          sUrl = flagUrl;
        });
      } else {
        print('Failed to fetch country data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching country data: $e');
    }
  }

  Map<String, dynamic> replaceNullsWithZero(Map<String, dynamic> data) {
    return data.map((key, value) => MapEntry(key, value ?? 0));
  }

  String formatNumber(int number) {
    if (number >= 1000 && number < 1000000) {
      double result = number / 1000.0;
      return '${result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1)}k';
    } else if (number >= 1000000) {
      double result = number / 1000000.0;
      return '${result.toStringAsFixed(result.truncateToDouble() == result ? 0 : 1)}M';
    } else {
      return number.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF0B0B0B),
      appBar: AppBar(
        title: Text('Leaderboards'),
        backgroundColor: Color(0XFF0B0B0B),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Global'),
            Tab(text: 'Hattrick Seasons'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FutureBuilder<List<AUser>>(
            future: _fetchUsersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final users = snapshot.data!;
                fetchCountryFlag(
                  users.first.city,
                );
                return ListView(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 34),
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                              image: NetworkImage(xpUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(users.first.city,
                            style: GoogleFonts.poppins(
                                fontSize: 8,
                                fontWeight: FontWeight.w300,
                                color: Color.fromARGB(191, 255, 255, 255))),
                        Text(
                          users.first.username,
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                        SizedBox(height: 13),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "xp.png",
                              width: 21,
                              height: 21,
                              fit: BoxFit.fill,
                            ),
                            Text(formatNumber(users.first.practice_points),
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal)),
                            SizedBox(width: 11),
                            Image.asset(
                              "logo.PNG",
                              width: 21,
                              height: 21,
                              fit: BoxFit.fill,
                            ),
                            Text(users.first.hattricks.toString(),
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal)),
                          ],
                        ),
                        SizedBox(height: 17),
                        Container(
                            width: 30,
                            height: 45,
                            color: Colors.black,
                            child: Center(
                                child: Text("1",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold))))
                      ],
                    ),
                    for (AUser user in users)
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: Row(
                          children: [
                            SizedBox(width: 12),
                            Text((users.indexOf(user) + 1).toString(),
                                textAlign: TextAlign.left,
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500)),
                            SizedBox(
                              width: 15,
                            ),
                            Text((user.username).toString(),
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500)),
                            Spacer(),
                            Image.asset(
                              "xp.png",
                              width: 21,
                              height: 21,
                              fit: BoxFit.fill,
                            ),
                            Text(formatNumber(user.practice_points),
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal)),
                            SizedBox(width: 11),
                            Image.asset(
                              "logo.PNG",
                              width: 21,
                              height: 21,
                              fit: BoxFit.fill,
                            ),
                            Text(user.hattricks.toString(),
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal)),
                            SizedBox(width: 12),
                          ],
                        ),
                      )
                  ],
                );
              }
            },
          ),
          FutureBuilder<List<AUser>>(
            future: _fetchSuperUsersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final superUsers = snapshot.data!;

                fetchSflag(superUsers.first.city);
                return ListView(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 34),
                        Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                              image: NetworkImage(sUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(superUsers.first.city,
                            style: GoogleFonts.poppins(
                                fontSize: 8,
                                fontWeight: FontWeight.w300,
                                color: Color.fromARGB(191, 255, 255, 255))),
                        Text(
                          superUsers.first.username,
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                        SizedBox(height: 13),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "win.png",
                              width: 21,
                              height: 21,
                              fit: BoxFit.fill,
                            ),
                            Text(formatNumber(superUsers.first.superPoints),
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal)),
                          ],
                        ),
                        SizedBox(height: 17),
                        Container(
                            width: 30,
                            height: 45,
                            color: Colors.black,
                            child: Center(
                                child: Text("1",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold))))
                      ],
                    ),
                    for (AUser user in superUsers)
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: Row(
                          children: [
                            SizedBox(width: 12),
                            Text((superUsers.indexOf(user) + 1).toString(),
                                textAlign: TextAlign.left,
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500)),
                            SizedBox(
                              width: 15,
                            ),
                            Text((user.username).toString(),
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500)),
                            Spacer(),
                            Image.asset(
                              "win.png",
                              width: 21,
                              height: 21,
                              fit: BoxFit.fill,
                            ),
                            Text(formatNumber(user.superPoints),
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal)),
                            SizedBox(width: 12),
                          ],
                        ),
                      )
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
