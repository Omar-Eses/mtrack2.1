import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mtrack/helper/ui_helper.dart';
import 'package:mtrack/models/user_model.dart';
import 'package:mtrack/utils/enums.dart';

class AddMemberViewModel extends ChangeNotifier {
  TextEditingController search = TextEditingController();
  List<UserModel> users = [];
  Future<QuerySnapshot<Map<String, dynamic>>> getUserInfo() {
    Future<QuerySnapshot<Map<String, dynamic>>> users = FirebaseFirestore
        .instance
        .collection('users')
        .where('fName', isGreaterThanOrEqualTo: search.text)
        .where('fName', isLessThanOrEqualTo: '${search.text}\uf8ff')
        .get();
    return users;
  }

  void clearSearch() {
    users = [];
    notifyListeners();
  }

  Map<String, dynamic> convertQuerySnapshotToMap(QuerySnapshot snapshot) {
    Map<String, dynamic> result = {};

    for (var doc in snapshot.docs) {
      result[doc.id] = doc.data();
    }

    return result;
  }

  Future<void> searchUser() async {
    users = [];
    notifyListeners();
    final snapshot = await getUserInfo();
    for (var element in snapshot.docs) {
      UserModel userModel = UserModel.fromJson(element.data());
      users.add(userModel);
      notifyListeners();
      print(userModel.email);
    }

    notifyListeners();
    // final searchValue = search.text;
    // FirebaseFirestore firestore = FirebaseFirestore.instance;
    //
    // // Clear the users list
    // users = [];
    // notifyListeners();
    //
    // // Perform the search query
    // final QuerySnapshot querySnapshot = await firestore
    //     .collection('users')
    //     // .where('fName', arrayContains: searchValue)
    //     .get();
    //
    // print(querySnapshot.docs.length);
    // // Iterate over the search results
    // for (var doc in querySnapshot.docs) {
    //   // Create a UserModel object from the document data
    //   UserModel userModel =
    //       UserModel.fromJson(doc.data() as Map<String, dynamic>);
    //   if (searchValue == userModel.email ||
    //       searchValue == userModel.fName ||
    //       searchValue == userModel.lName) {
    //     users.add(userModel);
    //     print(userModel.email);
    //   }
    //   users.add(userModel);
    //   print(userModel.email);
    // }
    // notifyListeners();
  }

  List<UserModel> userAddToMember = [];

  Future getMemberUser(String teamId) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection("teams")
        .doc(teamId)
        .get()
        .then((value) {
      value.data()!['membersInTeam'].forEach((e) {
        UserModel userModel = UserModel.fromJson(e);
        userAddToMember.add(userModel);
      });
      notifyListeners();
      print("///////////////");
      print(userAddToMember[0].email);
    });
  }

  List<Map<String, dynamic>> allUsersMap = [];

  Future<void> addUserToTeam(
      {required String teamId, required UserModel userAdd}) async {
    try {
      allUsersMap = [];
      notifyListeners();
      if (!userAddToMember.contains(userAdd)) {
        String? userEmail = FirebaseAuth.instance.currentUser!.email;
        DocumentReference teamRef = FirebaseFirestore.instance
            .collection('users')
            .doc(userEmail)
            .collection('teams')
            .doc(teamId);

        userAddToMember.add(userAdd);
        for (var element in userAddToMember) {
          UserModel userModel = UserModel(
            email: element.email,
            fName: element.fName,
            lName: element.lName,
            uid: element.uid,
            image: element.image,
          );

          allUsersMap.add(userModel.toMap());
        }
        await getMemberUser(teamId);

        teamRef.update({"membersInTeam": allUsersMap});
        DocumentSnapshot teamSnapshot = await teamRef.get();
        if (teamSnapshot.exists) {
          UiMethods.showSnackBar(
              text: 'added successfully', status: SnakeBarStatus.success);
        }
      } else {
        UiMethods.showSnackBar(text: 'contain', status: SnakeBarStatus.error);
      }
    } on FirebaseException catch (err) {
      print(err);
      UiMethods.showSnackBar(
          text: 'member already added', status: SnakeBarStatus.error);
    }
  }

  Future<void> addToTeam(
      {required String teamId, required UserModel userModel}) async {
    try {
      if (checkExist(teamId: teamId, userModel: userModel) == true) {
        UiMethods.showSnackBar(text: "Contain", status: SnakeBarStatus.error);
      }
      FirebaseFirestore.instance
          .collection('teams')
          .doc(teamId)
          .collection('users')
          .doc(userModel.email)
          .set(userModel.toMap())
          .then((value) => UiMethods.showSnackBar(
                text: "Addedd",
                status: SnakeBarStatus.success,
              ));
    } on FirebaseException catch (err) {
      print(err.toString());
    }
  }

  bool exists = false;
  Future<bool> checkExist(
      {required String teamId, required UserModel userModel}) async {
    try {
      await FirebaseFirestore.instance
          .collection("teams")
          .doc(teamId)
          .collection('users')
          .doc(userModel.email)
          .get()
          .then((doc) {
        print(doc.exists);
        exists = doc.exists;
      });
      return exists;
    } catch (e) {
      // If any error
      return false;
    }
  }
}
//test edit
