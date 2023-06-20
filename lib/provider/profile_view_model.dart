import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mtrack/helper/cache_helper.dart';

class ProfileViewModel extends ChangeNotifier {
  logout(BuildContext context) {
    FirebaseAuth.instance.signOut().then((value) {
      CacheHelper.removeData(key: 'uid');
      Navigator.pushReplacementNamed(context, '/');
    });
  }
  
}
