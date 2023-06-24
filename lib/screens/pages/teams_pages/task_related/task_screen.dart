// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:mtrack/models/task_model.dart';
import 'package:mtrack/provider/task_view_model.dart';
import 'package:mtrack/screens/pages/teams_pages/task_related/task_content.dart';
import 'package:mtrack/screens/pages/teams_pages/task_related/task_history.dart';
import 'package:provider/provider.dart';

import '../../../../models/team_model.dart';

class TaskScreen extends StatefulWidget {
  TaskModel? task;
  TeamModel? teamModel;
  TaskScreen({
    Key? key,
    required this.task,
    this.teamModel,
  }) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  @override
  void initState() {
    Future.microtask(() =>
        context.read<TaskViewModel>().getAllUserInTasks(widget.task!.taskId!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TaskViewModel>(context);
    final selectedTask = taskViewModel.selectedTask;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Task page'),
          actions: [
            widget.teamModel == null
                ? SizedBox()
                : IconButton(
                    onPressed: () {
                      taskViewModel.deleteTask(
                        taskModel: widget.task!,
                        teamId: widget.teamModel!.teamId!,
                        context: context,
                      );
                    },
                    icon: const Icon(Icons.delete_outline),
                  )
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Task Content'),
              Tab(text: 'Task History'),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: InkWell(
          onTap: () {
            taskViewModel.submitTasks(
                taskId: widget.task!.taskId!, context: context);
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            width: MediaQuery.of(context).size.width,
            height: 65,
            color: Colors.blueAccent.withOpacity(0.8),
            child: Center(
              child: Text(
                "Submit",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            TaskContent(
              taskModel: widget.task!,
              teamModel: widget.teamModel ?? null,
            ),
            TaskHistoryScreen(
              taskHistory: [
                // Provider.of<TaskViewModel>(context).selectedTask?.taskHistory ?? [],
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteTaskConfirmation(BuildContext context, String? taskId) {
    final taskViewModel = context.watch<TaskViewModel>();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete your task?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // await taskViewModel.deleteTask(taskId: , teamId: ,);

                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
