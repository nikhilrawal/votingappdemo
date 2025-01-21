import 'package:flutter/material.dart';
import 'package:votingindia/screens/admin_screen.dart';
import 'package:votingindia/screens/home_screen.dart';
import 'package:votingindia/screens/login_screen.dart';
import 'package:votingindia/screens/main.dart';
import 'package:votingindia/screens/profile_screen.dart';
import 'package:votingindia/screens/signup_screen.dart';
import 'package:votingindia/utils/theme.dart';

void main() {
  runApp(VotingApp());
}

class VotingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voting App',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/admin': (context) => AdminScreen(),
        '/profile': (context) => ProfileScreen(),
        '/main': (context) => MainScreen(),
        '/signup': (context) => SignupScreen(),
      },
    );
  }
}
