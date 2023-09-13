import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  int? uid;
  String? FullName;
  String? username;
  String? city;
  String? email;
  int? earning_balance;
  int? coins;
  int? practice_points;
  bool? is_subscribed;
  int? super_points;

  Future<void> delete() async {
    final response = await http.post(Uri.parse('http://localhost:5000/delete'),
        body: jsonEncode({'uid': uid.toString()}));
  }

  User({
    this.uid,
    this.username,
    this.FullName,
    this.city,
    this.coins,
    this.earning_balance,
    this.email,
    this.is_subscribed,
    this.practice_points,
    this.super_points,
  });
}

class HattrickAuth {
  User? currentuser;

  Future<void> RegisterUser({
    String? city,
    String? username,
    String? full_name,
    String? email,
    String? password,
  }) async {
    final response = await http.post(
      Uri.parse('http://localhost:5000/register'),
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
      Login(email, password);
      this.PasswordlessSignIn();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> PasswordlessSignIn() async {
    final preferences = await SharedPreferences.getInstance();

    final username = preferences.getString('username');

    if (username != null) {
      final response = await http.post(
        Uri.parse('http://localhost:5000/auth_user'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username.toString(),
        }),
      );

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
        );
      } else {
        throw Exception(response.body);
      }
    } else {
      throw Exception('Login First');
    }
  }

  Future<User?> Login(email, password) async {
    final response = await http.post(Uri.parse('http://localhost:5000/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email.toString(),
          'password': password.toString(),
        }));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final preferences = await SharedPreferences.getInstance();

      // Save the 'username' data to local storage
      preferences.setString('username', data['username']);
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
      );
      this.PasswordlessSignIn();

      return currentuser;
    } else {
      print("Failed To Log User In");
      currentuser = null;
      return currentuser;
    }
  }
}
