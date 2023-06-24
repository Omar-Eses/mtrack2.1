import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:mtrack/helper/ui_helper.dart';
import 'package:mtrack/models/team_model.dart';
import 'package:mtrack/models/user_model.dart';
import 'package:mtrack/screens/pages/home_pages/home.dart';
import 'package:mtrack/utils/enums.dart';

class TeamViewModel extends ChangeNotifier {
  // CRUD team operations
  TextEditingController teamName = TextEditingController();
  TextEditingController teamDescription = TextEditingController();
  TextEditingController teamMembers = TextEditingController();
  GlobalKey<FormState> teamFormKey = GlobalKey<FormState>();

  bool isLoading = false;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final key = GlobalKey<ExpandableFabState>();
  bool isAdmin = false;

  Future<void> registerTeam({
    required BuildContext context,
    required String fName,
    required String lName,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      await createTeam(fName: fName, lName: lName);
    } catch (ex) {
      UiMethods.showSnackBar(
        text: 'Failed to create team',
        status: SnakeBarStatus.error,
      );
    }
  }

  // CREATE team operation
  Future<void> createTeam({
    required String fName,
    required String lName,
  }) async {
    isLoading = true;
    notifyListeners();

    DocumentReference docRef = firestore.collection('teams').doc();
    String teamId = docRef.id;

    TeamModel teamModel = TeamModel(
      name: teamName.text,
      desc: teamDescription.text,
      owner: FirebaseAuth.instance.currentUser!.email.toString(),
      teamId: teamId,
      tasks: [],
      members: [],
      ownerName: "$fName $lName",
    );
    // add team to the user's teams
    await firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .update({
      'myTeams': FieldValue.arrayUnion([teamId]),
    });

    await docRef.set(teamModel.toMap()).then(
      (value) {
        teamName.clear();
        teamDescription.clear();
        teamMembers.clear();
        UiMethods.showSnackBar(
            text: "Team created successfully", status: SnakeBarStatus.success);
        readTeams();
      },
    );
  }

  List<TeamModel> teamModelList = [];
  // Read teams operation
  Future<List<TeamModel>> readTeams() async {
    isLoading = true;
    teamModelList = [];
    notifyListeners();

    try {
      DocumentSnapshot userSnap = await firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .get();

      final userData = userSnap.data() as Map<String, dynamic>?;
      final userTeams = userData?['myTeams'];
      if (userTeams != null && userTeams.isNotEmpty) {
        for (var teamId in userTeams) {
          DocumentSnapshot teamSnap =
              await firestore.collection('teams').doc(teamId).get();
          final teamData = teamSnap.data() as Map<String, dynamic>?;
          final owner = teamData?['owner'];
          if (owner == FirebaseAuth.instance.currentUser!.email) {
            isAdmin = true;
          } else {
            isAdmin = false;
          }
          TeamModel teamModel = TeamModel.fromJson(teamData!);
          teamModelList.add(teamModel);
        }
      }

      isLoading = false;
      notifyListeners();
      return teamModelList;
    } catch (err) {
      print(err);
      return [];
    }
  }

  // Update team operation
  Future<void> updateTeam(
      {required String teamId, required TeamModel team}) async {
    isLoading = true;
    notifyListeners();

    try {
      await firestore.collection('teams').doc(teamId).update(team.toMap());
      UiMethods.showSnackBar(
          text: "Team updated successfully", status: SnakeBarStatus.success);
    } catch (ex) {
      UiMethods.showSnackBar(
          text: "Failed to update team", status: SnakeBarStatus.error);
    }

    isLoading = false;
    notifyListeners();
  }

  // update team members
  Future<void> updateTeamMembers(
      {required String teamId, required List<String> members}) async {
    isLoading = true;
    notifyListeners();

    try {
      await firestore.collection('teams').doc(teamId).update({
        'members': members,
      });
      UiMethods.showSnackBar(
          text: "Team members updated successfully",
          status: SnakeBarStatus.success);
    } catch (ex) {
      UiMethods.showSnackBar(
          text: "Failed to update team members", status: SnakeBarStatus.error);
    }

    isLoading = false;
    notifyListeners();
  }

  // Delete team operation
  Future<void> deleteTeam({required String teamId}) async {
    isLoading = true;
    notifyListeners();

    try {
      await firestore.collection('teams').doc(teamId).delete();
      await firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .update({
        'myTeams': FieldValue.arrayRemove([teamId]),
      });
      UiMethods.showSnackBar(
          text: "Team deleted successfully", status: SnakeBarStatus.success);
    } catch (ex) {
      UiMethods.showSnackBar(
          text: "Failed to delete team", status: SnakeBarStatus.error);
    }

    isLoading = false;
    notifyListeners();
  }

  leaveTeam(String teamId, BuildContext context) async {
    final docSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get();
    List queue = docSnap.get('myTeams');
    if (queue.contains(teamId) == true) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .update({
        "myTeams": FieldValue.arrayRemove([teamId])
      }).then((value) {
        UiMethods.showSnackBar(text: "Leave", status: SnakeBarStatus.success);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      });
    } else {
      UiMethods.showSnackBar(text: "Not Found", status: SnakeBarStatus.error);
    }
  }

  List<UserModel> teamMember = [];
  getTeamMember(String teamId) {
    teamMember = [];
    notifyListeners();
    FirebaseFirestore.instance
        .collection('teams')
        .doc(teamId)
        .collection('users')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        UserModel userModel = UserModel.fromJson(element.data());
        teamMember.add(userModel);
      });
      notifyListeners();
    });
  }

  deleteTeamMember({required String teamId, required String email}) {
    FirebaseFirestore.instance
        .collection('teams')
        .doc(teamId)
        .collection('users')
        .doc(email)
        .delete()
        .then((value) {
      UiMethods.showSnackBar(
          text: "User Deleted", status: SnakeBarStatus.success);
      getTeamMember(teamId);
    });
  }
}
