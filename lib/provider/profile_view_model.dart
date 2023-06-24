import 'package:cloud_firestore/cloud_firestore.dart';
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

  deleteAccount(BuildContext context) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .delete()
        .then((value) {
      FirebaseAuth.instance.currentUser!.delete();
      CacheHelper.removeData(key: 'uid');
      Navigator.pushReplacementNamed(context, '/');
    });
  }
}
