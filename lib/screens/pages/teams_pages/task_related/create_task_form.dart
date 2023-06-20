import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mtrack/provider/task_view_model.dart';
import 'package:mtrack/widgets/custom_txt_form_field.dart';
import 'package:provider/provider.dart';

class CreateTaskForm extends StatefulWidget {
  final List members;
  String? teamId;

  CreateTaskForm({Key? key, required this.members, required this.teamId})
      : super(key: key);

  @override
  State<CreateTaskForm> createState() => _CreateTaskFormState();
}

class _CreateTaskFormState extends State<CreateTaskForm> {
  Map<String, bool>? assignedMembers = {};
  DateTime? startDate;
  DateTime? dueDate;
  @override
  Widget build(BuildContext context) {
    final newTask = context.watch<TaskViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('add new task'),
        actions: [
          IconButton(
            onPressed: () async {
              if (newTask.taskFormKey.currentState != null &&
                  newTask.taskFormKey.currentState!.validate()) {
                String? userEmail = FirebaseAuth.instance.currentUser!.email;
                await newTask.createTask(
                  context: context,
                  taskMaker: userEmail!,
                  startDate: startDate!,
                  finishDate: dueDate!,
                  teamId: widget.teamId!,
                );
                // go back to team screen
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.check_outlined),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Form(
          key: newTask.taskFormKey,
          child: Center(
            child: Column(
              children: [
                CustomTextFormField(
                  labelTxt: 'Task Title',
                  height: 30,
                  width: 200,
                  fixedIcon: Icons.task_alt_outlined,
                  controller: newTask.taskName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a task title';
                    } else if (value.length > 20) {
                      return 'Please enter a shorter title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 7),
                CustomTextFormField(
                  labelTxt: 'Task Description',
                  height: 10,
                  width: 200,
                  fixedIcon: Icons.description_outlined,
                  controller: newTask.taskDescription,
                ),
                const SizedBox(height: 7),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () async {
                        DateTime? sDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 60)),
                        );
                        print(sDate);
                        setState(() {
                          startDate = sDate ?? DateTime.now();
                        });
                        print(startDate);
                      },
                      icon: const Icon(Icons.calendar_today_outlined),
                      label: const Text('Set Start Date'),
                    ),
                    startDate == null
                        ? Text('')
                        : OutlinedButton.icon(
                            onPressed: () async {
                              DateTime? dDate = await showDatePicker(
                                context: context,
                                initialDate: startDate!,
                                firstDate: startDate!,
                                lastDate: startDate!.add(Duration(days: 60)),
                              );
                              print(dDate);
                              setState(() {
                                dueDate = dDate ??
                                    DateTime.now().add(Duration(days: 7));
                              });
                              print(dueDate);
                            },
                            icon: const Icon(Icons.calendar_today_outlined),
                            label: const Text('Set Due Date'),
                          ),
                  ],
                ),
                const SizedBox(height: 7),
                const Row(
                  children: [
                    Text(
                      'Attachments',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Handle upload attachment action
                  },
                  child: const Text('Upload Attachment'),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      // color: Colors.red,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () async {
                        if (newTask.taskFormKey.currentState != null &&
                            newTask.taskFormKey.currentState!.validate()) {
                          String? userEmail =
                              FirebaseAuth.instance.currentUser!.email;
                          await newTask.createTask(
                            context: context,
                            taskMaker: userEmail!,
                            startDate: startDate!,
                            finishDate: dueDate!,
                            teamId: widget.teamId!,
                          );
                          // go back to team screen
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Done'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
