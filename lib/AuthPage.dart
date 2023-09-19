import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Homepage.dart';
import 'Models/user.dart';
import 'login_or_register.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final auth = HattrickAuth();

  @override
  void initState() {
    super.initState();
    auth.PasswordlessSignIn().then((_) {
      setState(() {}); // Refresh the widget after sign-in.
    });

    print(auth.currentuser);
  }

  Future<bool> checkUsername() async {
    final preferences = await SharedPreferences.getInstance();
    final uname = preferences.getString("username");
    return uname!.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkUsername(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While the Future is still running, return a loading indicator or something else
          return Scaffold(
            body: Center(child: RiveAnimation.asset('assets/load.riv')),
          );
          ;
        } else if (snapshot.hasError) {
          // If there was an error during the Future execution
          return Text('Error: ${snapshot.error}');
        } else {
          // If the Future completed successfully
          bool isUsernameValid = snapshot.data ?? false;

          if (auth.currentuser == null) {
            if (isUsernameValid) {
              return Scaffold(
                body: Center(child: RiveAnimation.asset('assets/load.riv')),
              );
            } else {
              print('Logging Inn');
              return LoginOrRegister();
            }
          } else {
            print(auth.currentuser);
            return HomePage();
          }
        }
      },
    );
  }
}
