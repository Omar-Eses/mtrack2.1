import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mtrack/helper/ui_helper.dart';
import 'package:mtrack/models/task_model.dart';
import 'package:mtrack/utils/enums.dart';

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
    required String teamId,
  }) async {
    try {
      isLoading = true;
      notifyListeners();
      print(teamId);
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
      );

      // add task to tasks collection
      await docRef.set(taskModel.toMap());

      // Update tasks list in team document
      final teamDocRef = firestore.collection('teams').doc(teamId);
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
  Future<void> deleteTask({
    required String taskId,
    required String teamId,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      // delete task from tasks collection
      await tasksCollection.doc(taskId).delete();

      // delete task from team document
      final teamDocRef = firestore.collection('teams').doc(teamId);
      final tasksList = await teamDocRef.get().then((teamSnap) {
        final List<dynamic>? existingTasks = teamSnap['tasks'];
        if (existingTasks != null) {
          existingTasks.remove(taskId);
          return existingTasks;
        } else {
          return [];
        }
      });

      await teamDocRef.update({'tasks': tasksList}).then((value) {
        UiMethods.showSnackBar(
            text: 'Task deleted', status: SnakeBarStatus.success);
      });
    } catch (err) {
      UiMethods.showSnackBar(
          text: 'Failed to delete task', status: SnakeBarStatus.error);
      debugPrint('Failed to delete task: $err');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

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
}
