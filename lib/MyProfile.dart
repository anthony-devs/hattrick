import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('My Profile')),
    );
  }
}
