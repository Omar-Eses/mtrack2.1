import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:mtrack/helper/ui_helper.dart';
import 'package:mtrack/models/task_model.dart';
import 'package:mtrack/models/user_model.dart';
import 'package:mtrack/utils/enums.dart';

class AssignViewModel extends ChangeNotifier {
  List<UserModel> allUsers = [];
  getAllUserInTeam(String teamId) {
    allUsers = [];
    notifyListeners();

    FirebaseFirestore.instance
        .collection('teams')
        .doc(teamId)
        .collection('users')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        UserModel userModel = UserModel.fromJson(element.data());
        allUsers.add(userModel);
      });
      notifyListeners();
    });
  }

  bool exists = false;
  Future<bool> checkExist(
      {required String tasksId, required UserModel userModel}) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userModel.email)
          .collection('tasks')
          .doc(tasksId)
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

  assignUser(
      {required TaskModel taskModel, required UserModel userModel}) async {
    if (await checkExist(tasksId: taskModel.taskId!, userModel: userModel) ==
        true) {
      UiMethods.showSnackBar(text: "Contain", status: SnakeBarStatus.error);
    } else {
      FirebaseFirestore.instance
          .collection('users')
          .doc(userModel.email)
          .collection('tasks')
          .doc(taskModel.taskId)
          .set(taskModel.toMap())
          .then((value) {
        FirebaseFirestore.instance
            .collection('tasks')
            .doc(taskModel.taskId)
            .collection('users')
            .doc(userModel.email)
            .set(userModel.toMap())
            .then((value) => UiMethods.showSnackBar(
                text: "Success Add User", status: SnakeBarStatus.success));
      }).catchError((error) {
        print(error);
      });
    }
  }
}
