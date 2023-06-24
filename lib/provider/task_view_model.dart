import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mtrack/helper/ui_helper.dart';
import 'package:mtrack/models/task_model.dart';
import 'package:mtrack/models/team_model.dart';
import 'package:mtrack/models/user_model.dart';
import 'package:mtrack/screens/pages/home_pages/home.dart';
import 'package:mtrack/utils/enums.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class TaskViewModel extends ChangeNotifier {
  // CRUD task operations
  TextEditingController taskName = TextEditingController();
  TextEditingController taskDescription = TextEditingController();
  TextEditingController taskMembers = TextEditingController();
  TextEditingController taskStatus = TextEditingController();
  Map<String, bool> taskAssignedMembers = {};
  TextEditingController taskAttachments = TextEditingController();
  GlobalKey<FormState> taskFormKey = GlobalKey<FormState>();
  bool isLoading = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TaskModel? _selectedTask;
  List<DocumentSnapshot> tasksInTeamDocument = [];
  TaskModel? get selectedTask => _selectedTask;

  void setSelectedTask(TaskModel? task) {
    _selectedTask = task;
    notifyListeners();
  }

  final CollectionReference tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  // CREATE task
  Future<void> createTask({
    required BuildContext context,
    required String taskMaker,
    required DateTime startDate,
    required DateTime finishDate,
    required TeamModel teamModel,
  }) async {
    try {
      if (file != null) {
        await uploadFile();
      }
      isLoading = true;
      notifyListeners();
      print(teamModel.teamId);
      DocumentReference docRef = firestore.collection('tasks').doc();
      String taskId = docRef.id;

      TaskModel taskModel = TaskModel(
        taskName: taskName.text,
        taskDescription: taskDescription.text,
        taskStatus: 'Not Started',
        assignedTo: [],
        startDate: DateFormat('dd-MM-yyyy').format(startDate),
        finishDate: DateFormat('dd-MM-yyyy').format(finishDate),
        taskId: taskId,
        attach: file == null ? "" : urlDownload,
        owner: FirebaseAuth.instance.currentUser!.email.toString(),
        status: "In Progress",
      );

      // add task to tasks collection
      await docRef.set(taskModel.toMap()).then((value) async {
        await getAllTasks(teamModel.tasks!);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      });

      // Update tasks list in team document
      final teamDocRef = firestore.collection('teams').doc(teamModel.teamId);
      final tasksList = await teamDocRef.get().then((teamSnap) {
        final List<dynamic>? existingTasks = teamSnap['tasks'];
        if (existingTasks != null) {
          existingTasks.add(taskId);
          return existingTasks;
        } else {
          return [taskId];
        }
      });

      await teamDocRef.update({'tasks': tasksList}).then((value) {
        taskName.clear();
        taskStatus.clear();
        taskMembers.clear();
        taskAssignedMembers.clear();
        taskAttachments.clear();
        debugPrint('Task CREATE success');
        UiMethods.showSnackBar(text: "Success", status: SnakeBarStatus.success);
      });
    } catch (err) {
      print(err);
      UiMethods.showSnackBar(
          text: 'Failed to create task', status: SnakeBarStatus.error);
      debugPrint('Task was not created because:\n$err');
    }
  }

  // READ all tasks in tasks list
  List<TaskModel> taskModelList = [];
  Future<List<TaskModel>> readTasks(String docId) async {
    isLoading = true;
    taskModelList = [];
    notifyListeners();
    try {
      DocumentSnapshot teamSnapshot =
          await FirebaseFirestore.instance.collection('teams').doc(docId).get();
      // read tasks from teams collection then go back to tasks collection and read based on allTasks list it should read them
      final taskData = teamSnapshot.data() as Map<String, dynamic>;
      final tasksId = taskData['tasks'];
      if (tasksId != null && tasksId.isNotEmpty) {
        for (var taskId in tasksId) {
          DocumentSnapshot taskSnap =
              await firestore.collection('tasks').doc(taskId).get();
          final taskData = taskSnap.data() as Map<String, dynamic>;
          final taskModel = TaskModel.fromJson(taskData);
          taskModelList.add(taskModel);
          print(taskModel.toMap());
        }
      }
      isLoading = false;
      notifyListeners();
      return taskModelList;
    } catch (err) {
      // UiMethods.showSnackBar(
      //     text: 'Failed to read tasks', status: SnakeBarStatus.error);
      debugPrint('Failed to read tasks: $err');
      return [];
    }
  }

  List<TaskModel> allTasks = [];
  List<UserModel> allUserInTask = [];
  getAllTasks(List tasks) {
    allTasks = [];
    notifyListeners();
    tasks.forEach((element) {
      FirebaseFirestore.instance
          .collection('tasks')
          .doc(element)
          .get()
          .then((value) {
        TaskModel taskModel = TaskModel.fromJson(value.data()!);
        allTasks.add(taskModel);
        notifyListeners();
      });
    });
  }

  getAllUserInTasks(String taskId) {
    allUserInTask = [];
    notifyListeners();
    FirebaseFirestore.instance
        .collection('tasks')
        .doc(taskId)
        .collection('users')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        UserModel userModel = UserModel.fromJson(element.data());
        allUserInTask.add(userModel);
      });
      notifyListeners();
    });
  }

  // update task method
  Future<void> updateTask({
    required String taskId,
    required String taskName,
    required String taskDescription,
    required String taskStatus,
    required List<String> assignedTo,
    required String startDate,
    required String finishDate,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      await tasksCollection.doc(taskId).update({
        'taskName': taskName,
        'taskDescription': taskDescription,
        'taskStatus': taskStatus,
        'assignedTo': assignedTo,
        'startDate': startDate,
        'finishDate': finishDate,
      });
      UiMethods.showSnackBar(
          text: 'Task updated', status: SnakeBarStatus.success);
    } catch (err) {
      UiMethods.showSnackBar(
          text: 'Failed to update task', status: SnakeBarStatus.error);
      debugPrint('Failed to update task: $err');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // delete task field from team document and from tasks collection
  // Future<void> deleteTask({
  //   required String taskId,
  //   required String teamId,
  // }) async {
  //   isLoading = true;
  //   notifyListeners();
  //   try {
  //     // delete task from tasks collection
  //     await tasksCollection.doc(taskId).delete();
  //
  //     // delete task from team document
  //     final teamDocRef = firestore.collection('teams').doc(teamId);
  //     final tasksList = await teamDocRef.get().then((teamSnap) {
  //       final List<dynamic>? existingTasks = teamSnap['tasks'];
  //       if (existingTasks != null) {
  //         existingTasks.remove(taskId);
  //         return existingTasks;
  //       } else {
  //         return [];
  //       }
  //     });
  //
  //     await teamDocRef.update({'tasks': tasksList}).then((value) {
  //       UiMethods.showSnackBar(
  //           text: 'Task deleted', status: SnakeBarStatus.success);
  //     });
  //   } catch (err) {
  //     UiMethods.showSnackBar(
  //         text: 'Failed to delete task', status: SnakeBarStatus.error);
  //     debugPrint('Failed to delete task: $err');
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }

  void toggleAssignMember(String email) {
    if (taskAssignedMembers.containsKey(email)) {
      taskAssignedMembers.remove(email);
    } else {
      taskAssignedMembers[email] = true;
    }
    notifyListeners();
  }

  Future<void> updateTaskStatus(TaskStatus newStatus, String docId) async {
    DocumentReference taskRef = firestore.collection('tasks').doc(docId);

    await taskRef.update({'task': newStatus.toString().split('.').last});
    notifyListeners();
  }

  Future downloadFile(reference) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/${reference}");

    await reference.writeToFile(file);
    UiMethods.showSnackBar(text: "Downloaded", status: SnakeBarStatus.success);
  }

  getFileName(String link) {
    RegExp regExp = new RegExp(r'.+(\/|%2F)(.+)\?.+');
    //This Regex won't work if you remove ?alt...token
    var matches = regExp.allMatches(link);

    var match = matches.elementAt(0);

    return "${Uri.decodeFull(match.group(2)!)}";
  }

  UploadTask? task;
  File? file;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    file = File(path);
    notifyListeners();
  }

  var urlDownload;
  Future uploadFile() async {
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, file!);
    notifyListeners();

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
  }

  uploadFileToTask({required TaskModel taskModel}) async {
    await uploadFile();
    FirebaseFirestore.instance
        .collection('tasks')
        .doc(taskModel.taskId)
        .update({
      "attach": "$urlDownload",
    }).then((value) {
      file = null;
      notifyListeners();
    });
  }

  Future<String?> getFileFromFirebaseStorage(String fileName) async {
    try {
      // Create a reference to the file
      Reference reference = FirebaseStorage.instance.ref().child(fileName);

      // Get the download URL for the file
      String downloadURL = await reference.getDownloadURL();

      // Return the download URL
      return downloadURL;
    } catch (e) {
      print('Error: $e');
    }

    return null; // File not found or an error occurred
  }

  deleteTask(
      {required TaskModel taskModel,
      required String teamId,
      required BuildContext context}) async {
    if (taskModel.owner == FirebaseAuth.instance.currentUser!.email) {
      final docSnap = await FirebaseFirestore.instance
          .collection('teams')
          .doc(teamId)
          .get();
      List queue = docSnap.get('tasks');
      if (queue.contains(taskModel.taskId) == true) {
        FirebaseFirestore.instance.collection('teams').doc(teamId).update({
          "tasks": FieldValue.arrayRemove([taskModel.taskId])
        }).then((value) {
          FirebaseFirestore.instance
              .collection('tasks')
              .doc(taskModel.taskId)
              .delete()
              .then((value) {
            UiMethods.showSnackBar(
                text: "Deleted", status: SnakeBarStatus.success);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          });
        });
      } else {
        UiMethods.showSnackBar(text: "Not Found", status: SnakeBarStatus.error);
      }
    }
  }

  String currentTaskStatue = "Completed";
  List<String> myTaskStatus = [
    "Completed",
    "In Progress",
    "In Progressd",
  ];

  submitTasks({required String taskId, required BuildContext context}) {
    if (currentTaskStatue != "") {
      FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .update({"status": currentTaskStatue}).then((value) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.email)
            .collection('tasks')
            .doc(taskId)
            .update({"status": currentTaskStatue}).then((value) {
          UiMethods.showSnackBar(
              text: "Success", status: SnakeBarStatus.success);
          Navigator.pop(context);
        });
      });
    }
  }

  changeStatus(String status) {
    currentTaskStatue = status;
    notifyListeners();
  }

  // TaskStatus? currentStatus;
  // TaskStatus getCurrentStatus(String status) {
  //   switch (status) {
  //     case 'notStarted':
  //       return TaskStatus.notStarted;
  //     case 'inProgress':
  //       return TaskStatus.inProgress;
  //     case 'completed':
  //       return TaskStatus.completed;
  //     default:
  //       return TaskStatus.notStarted;
  //   }
  // }
  //
  // String getStatusString(TaskStatus status) {
  //   switch (status) {
  //     case TaskStatus.notStarted:
  //       return 'Not Started';
  //     case TaskStatus.inProgress:
  //       return 'In Progress';
  //     case TaskStatus.completed:
  //       return 'Completed';
  //     default:
  //       return '';
  //   }
  // }
}

class FirebaseApi {
  static UploadTask? uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  static UploadTask? uploadBytes(String destination, Uint8List data) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putData(data);
    } on FirebaseException catch (e) {
      return null;
    }
  }
}
