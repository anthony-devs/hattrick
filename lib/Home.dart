import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hattrick/Leaderboard.dart';
import 'package:hattrick/MyProfile.dart';

import 'Homepage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> tabs = [HomePage(), LeaderBoard(), MyProfile()];

  dynamic changePage(int index) {
    setState(() {
      currentPage = tabs[index];
    });
  }

  Widget currentPage = HomePage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(800)),
        child: GNav(
            onTabChange: (index) {
              changePage(index);
            },
            iconSize: 16,
            color: Colors.grey,
            backgroundColor: Color.fromARGB(142, 227, 215, 255),
            tabBackgroundColor: Colors.transparent,
            activeColor: Color(0xFFAF89F6),
            gap: 2,
            tabs: const <GButton>[
              GButton(
                style: GnavStyle.oldSchool,
                icon: CupertinoIcons.home,
                text: 'Home',
              ),
              GButton(
                icon: CupertinoIcons.chart_bar,
                text: 'Leaderboards',
              ),
              GButton(
                icon: CupertinoIcons.person,
                text: 'Profile',
              ),
            ]),
      ),
      body: currentPage,
    );
  }
}
