import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mtrack/screens/authentication/authenticate.dart';
import 'package:mtrack/screens/pages/home_pages/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return either home or login pages

    return FirebaseAuth.instance.currentUser != null
        ? const HomeScreen()
        : const Authenticate();
  }
}
