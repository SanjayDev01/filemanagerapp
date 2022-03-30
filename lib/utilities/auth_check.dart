// ignore_for_file: unnecessary_null_comparison

import 'package:filemanagerapp/auth/signIn_screen.dart';
import 'package:filemanagerapp/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      //If the user is successfully Logged-In.
      return const HomeScreen();
    } else {
      //If the user is not Logged-In.
      return const SignInScreen();
    }
  }
}
