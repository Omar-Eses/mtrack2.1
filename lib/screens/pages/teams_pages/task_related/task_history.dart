import 'package:flutter/material.dart';
import 'package:mtrack/models/task_lifetime_model.dart';

class TaskHistoryScreen extends StatefulWidget {
  final List<taskLifeTimeModel> taskHistory;

  const TaskHistoryScreen({super.key, required this.taskHistory});

  @override
  State<TaskHistoryScreen> createState() => _TaskHistoryScreenState();
}

class _TaskHistoryScreenState extends State<TaskHistoryScreen> {
  List<taskLifeTimeModel> taskLifetimeChanges = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: taskLifetimeChanges.length,
        itemBuilder: (context, index) {
          var change = taskLifetimeChanges[index];
          return Card(
            child: ListTile(
              title: Text(change.action),
              subtitle: Text(change.user),
              trailing: Text(change.date.toString()),
            ),
          );
        },
      ),
    );
  }
}
