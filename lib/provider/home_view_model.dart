import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mtrack/models/task_model.dart';

import '../helper/cache_helper.dart';
import '../helper/ui_helper.dart';
import '../models/user_model.dart';
import '../utils/enums.dart';

class HomeViewModel extends ChangeNotifier {
  UserModel? userModel;
  void getUserData() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(CacheHelper.getData(key: 'uid'))
        .get()
        .then((value) {
      userModel = UserModel.fromJson(value.data()!);
      fName.text = userModel!.fName!;
      lName.text = userModel!.lName!;
      notifyListeners();
    });
  }

  // upload user profile image to firebase storage
  void pickProfileImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );
  }

  bool isLoading = false;

  List<TaskModel> userTasksList = [];
  removeList() {
    print("Remove");
    userTasksList = [];
    notifyListeners();
  }

  getUserTasks() async {
    await removeList();

    notifyListeners();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection('tasks')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        print(element);
        TaskModel taskModel = TaskModel.fromJson(element.data());
        userTasksList.add(taskModel);
      });
      notifyListeners();
    });
  }

  // Future<List<TaskModel>> readTasks(String docId) async {
  //   isLoading = true;
  //
  //   try {
  //     DocumentSnapshot teamSnapshot =
  //         await FirebaseFirestore.instance.collection('teams').doc(docId).get();
  //     // read tasks from teams collection then go back to tasks collection and read based on allTasks list it should read them
  //     final taskData = teamSnapshot.data() as Map<String, dynamic>;
  //     final tasksId = taskData['tasks'];
  //     if (tasksId != null && tasksId.isNotEmpty) {
  //       for (var taskId in tasksId) {
  //         DocumentSnapshot taskSnap = await FirebaseFirestore.instance
  //             .collection('tasks')
  //             .doc(taskId)
  //             .get();
  //         final taskData = taskSnap.data() as Map<String, dynamic>;
  //         final taskModel = TaskModel.fromJson(taskData);
  //         taskModelList.add(taskModel);
  //         notifyListeners();
  //         print(taskModel.toMap());
  //       }
  //     }
  //     isLoading = false;
  //     notifyListeners();
  //     return taskModelList;
  //   } catch (err) {
  //     debugPrint('Failed to read tasks: $err');
  //     return [];
  //   }
  // }

  DateTime today = DateTime.now();
  void onDaySelected(DateTime day, DateTime focusedDay) {
    today = day;
    userTasksList = [];

    notifyListeners();
    getUserTasks();
    print(today);
    print(DateFormat('dd-MM-yyyy').format(today));
  }

  ////////
  final picker = ImagePicker();
  File? image;

  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      notifyListeners();
    } else {
      print("No image selected");
      notifyListeners();
    }
  }

  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool loading = false;
  void updateUser(BuildContext context, UserModel userModel) {
    loading = true;
    notifyListeners();
    if (image != null) {
      uploadProfileImage(context, userModel);
    } else {
      update(context, userModel);
    }
  }

  String? imageUrl;
  void uploadProfileImage(BuildContext context, UserModel userModel) {
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(image!.path).pathSegments.last}')
        .putFile(image!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        imageUrl = value;

        notifyListeners();
        update(context, userModel);

        print(value);
      }).catchError((error) {});
    }).catchError((error) {});
  }

  void update(BuildContext context, UserModel userModel) {
    loading = true;
    notifyListeners();

    FirebaseFirestore.instance.collection('users').doc(userModel.email).update({
      'fName': fName.text.isEmpty ? userModel.fName : fName.text,
      'lName': lName.text.isEmpty ? userModel.lName : lName.text,
      'image': imageUrl ?? userModel.image,
    }).whenComplete(() {
      print('Success');

      UiMethods.showSnackBar(text: "Done Edit", status: SnakeBarStatus.success);
      getUserData();
      loading = false;
      notifyListeners();
    }).catchError(
      (error) {
        loading = false;
        notifyListeners();
      },
    );
  }
}
