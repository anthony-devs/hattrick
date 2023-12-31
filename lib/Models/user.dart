import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../main.dart';

class User {
  String? uid;
  String? FullName;
  String? username;
  String? city;
  String? email;
  int? earning_balance;
  int? coins;
  int? practice_points;
  bool is_subscribed;
  int? super_points;
  dynamic? played;

  Future<void> delete() async {
    final response = await http.post(
        Uri.parse('https://hattrick-server-production.up.railway.app//delete'),
        body: jsonEncode({'uid': uid.toString()}));
  }

  User(
      {this.uid,
      this.username,
      this.FullName,
      this.city,
      this.coins,
      this.earning_balance,
      this.email,
      required this.is_subscribed,
      this.practice_points,
      this.super_points,
      this.played = 0});
}

class HattrickAuth {
  User? currentuser;

  Future<dynamic> RegisterUser({
    String? city,
    String? username,
    String? full_name,
    String? email,
    String? password,
  }) async {
    final response = await http.post(
      Uri.parse('https://hattrick-server-production.up.railway.app//register'),
      body: jsonEncode(<String, String>{
        'city': city.toString(),
        'FullName': full_name.toString(),
        'email': email.toString(),
        'username': username.toString(),
        'password': password.toString(),
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final preferences = await SharedPreferences.getInstance();

      // Save the 'username' data to local storage
      preferences.setString('username', data['username']);

      // You can now access the 'username' data from local storage like this:
      final savedUsername = preferences.getString('username');
      print('Username from local storage: $savedUsername');
      await Login(email, password);
      //this.PasswordlessSignIn();
    } else {
      throw Exception('Failed to load data');
    }

    return response;
  }

  Future<int> PasswordlessSignIn() async {
    final preferences = await SharedPreferences.getInstance();

    final username = preferences.getString('username');

    if (username != null) {
      final response = await http.post(
          Uri.parse(
              'https://hattrick-server-production.up.railway.app//auth_user'),
          body: jsonEncode(<String, String>{
            'username': username.toString(),
          }),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        this.currentuser = User(
            uid: data['uid'],
            FullName: data['FullName'],
            city: data['city'],
            coins: data['coins'],
            earning_balance: data['earning_balance'],
            email: data['email'],
            is_subscribed: data['is_subscribed'],
            practice_points: data['practice_points'],
            super_points: data['super_points'],
            username: data['username'],
            played: data['played']);
        print(data['uid']);
        return 200;
      } else {
        //throw Exception(response.body);
        return response.statusCode;
      }
    } else {
      //throw Exception('Login First');
      return 500;
    }
  }

  Future<int> Login(email, password) async {
    final response = await http.post(
        Uri.parse('https://hattrick-server-production.up.railway.app//login'),
        body: jsonEncode(<String, String>{
          'email': email.toString(),
          'password': password.toString(),
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final preferences = await SharedPreferences.getInstance();

      // Save the 'username' data to local storage
      preferences.setString('username', data['uid']);
      currentuser = User(
          uid: data['uid'],
          FullName: data['FullName'],
          city: data['city'],
          coins: data['coins'],
          earning_balance: data['earning_balance'],
          email: data['email'],
          is_subscribed: data['is_subscribed'],
          practice_points: data['practice_points'],
          super_points: data['super_points'],
          username: data['username'],
          played: data['played']);
      await this.PasswordlessSignIn();

      return 200;
    } else if (response.statusCode == 404) {
      return 404;
    } else if (response.statusCode == 400) {
      return 400;
    } else if (response.statusCode == 508) {
      return 508;
    } else {
      print("Failed To Log User In");
      currentuser = null;
      return 500;
    }
  }

  Future<void> logOut() async {
    final preferences = await SharedPreferences.getInstance();

    // Save the 'username' data to local storage
    preferences.remove("username");
    this.currentuser = null;

    runApp(MyApp());
  }
}
