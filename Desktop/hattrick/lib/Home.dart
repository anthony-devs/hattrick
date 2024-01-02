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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          color: Color(0xFF191919),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 6, bottom: 6),
          child: GNav(
              tabBorderRadius: 5,
              onTabChange: (index) {
                changePage(index);
              },
              iconSize: 16,
              color: Color(0xFF393838),
              tabBackgroundColor: Color.fromARGB(128, 43, 42, 42),
              activeColor: Color.fromARGB(172, 175, 137, 246),
              gap: 2,
              tabs: const <GButton>[
                GButton(
                  style: GnavStyle.oldSchool,
                  icon: Icons.home,
                  //text: 'Home',
                ),
                GButton(
                  icon: Icons.bar_chart,
                  //text: 'Leaderboards',
                ),
                GButton(
                  icon: Icons.person,
                  //text: 'Profile',
                ),
              ]),
        ),
      ),
      body: currentPage,
    );
  }
}
