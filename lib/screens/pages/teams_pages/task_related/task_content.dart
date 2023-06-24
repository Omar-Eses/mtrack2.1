import 'package:flutter/material.dart';
import 'package:mtrack/models/task_model.dart';
import 'package:mtrack/models/team_model.dart';
import 'package:mtrack/screens/pages/teams_pages/assign_user_screen.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import '../../../../provider/task_view_model.dart';

class TaskContent extends StatefulWidget {
  final TeamModel? teamModel;
  TaskModel taskModel;

  TaskContent({
    Key? key,
    required this.taskModel,
    this.teamModel,
  }) : super(key: key);

  @override
  State<TaskContent> createState() => _TaskContentState();
}

class _TaskContentState extends State<TaskContent> {
  @override
  void initState() {
    super.initState();
  }

  bool isTaskCompleted = false;
  double progress = 0.5;
  List<String> assignedPeople = ['John', 'Jane', 'Mark'];
  List<String> attachments = ['pic1.jpg', 'file2.pdf'];
  List<String> comments = [];

  void toggleTaskCompletion() {
    setState(() {
      isTaskCompleted = !isTaskCompleted;
    });
  }

  void updateProgress(double value) {
    setState(() {
      progress = value;
    });
  }

  void addComment(String comment) {
    setState(() {
      comments.add(comment);
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime startDate = DateTime.now();
    DateTime dueDate = DateTime.now().add(const Duration(days: 7));
    final tasks = context.watch<TaskViewModel>();

    // Future<void> selectStartDate() async {
    //   final selectedDate = await showDatePicker(
    //     context: context,
    //     initialDate: startDate,
    //     firstDate: DateTime(2022),
    //     lastDate: DateTime(2024),
    //   );
    //   if (selectedDate != null) {
    //     startDate = selectedDate;
    //   }
    // }

    // Future<void> selectDueDate() async {
    //   final selectedDate = await showDatePicker(
    //     context: context,
    //     initialDate: dueDate,
    //     firstDate: DateTime(2022),
    //     lastDate: DateTime(2024),
    //   );
    //   if (selectedDate != null) {
    //     dueDate = selectedDate;
    //   }
    // }

    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${widget.taskModel.taskName}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton(
                    dropdownColor: Theme.of(context).primaryColorLight,
                    isDense: true,
                    value: tasks.currentTaskStatue,
                    items: tasks.myTaskStatus.map((status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(
                          status,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) async {
                      tasks.changeStatus(value!);
                      // Remove setState as we are using Provider package
                      // tasks.currentStatus = value!;
                      // print(tasks.currentStatus);
                      // // Send to Firebase using the Provider method
                      // final updateTask =
                      //     Provider.of<TaskViewModel>(context, listen: false);
                      // await updateTask.updateTaskStatus(
                      //     tasks.currentStatus!, widget.taskModel.taskId!);
                      // widget.taskModel.taskStatus =
                      //     tasks.currentStatus.toString().split('.').last;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(value: progress),
              const SizedBox(height: 10),
              const Text(
                'Task Details',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5.0),
              Text(
                '${widget.taskModel.taskDescription}',
                maxLines: 3,
                softWrap: true,
                textAlign: TextAlign.start,
                style: const TextStyle(fontSize: 14.0),
              ),
              const SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      widget.taskModel.assignedTo!.isNotEmpty
                          ? Row(
                              children: widget.taskModel.assignedTo!
                                  .map((person) => CircleAvatar(
                                      child: Text(person.substring(0, 1))))
                                  .toList(),
                            )
                          : Text('No assigned people'),
                    ],
                  ),
                  widget.teamModel == null
                      ? SizedBox()
                      : IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AssignUserScreen(
                                          teamModel: widget.teamModel!,
                                          taskModel: widget.taskModel,
                                        )));
                            // widget.taskModel.assignedTo!.isNotEmpty
                            //     ? showAssignMemberPopup(context,
                            //         widget.taskModel.assignedTo as List<String>)
                            //     : null;
                          },
                          icon: const Icon(Icons.add_outlined),
                        ),
                ],
              ),
              const Divider(),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'FROM',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(
                        '${widget.taskModel.startDate.toString()}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      Text(
                        'TO',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(
                        '${widget.taskModel.finishDate.toString()}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),

                      // OutlinedButton.icon(
                      //   onPressed: selectStartDate,
                      //   icon: const Icon(Icons.calendar_today_outlined),
                      //   label: const Text('Set Start Date'),
                      // ),
                      // OutlinedButton.icon(
                      //   onPressed: selectDueDate,
                      //   icon: const Icon(Icons.calendar_today_outlined),
                      //   label: const Text('Set Due Date'),
                      // ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Attachments',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.attachment_sharp),
                        onPressed: () {
                          tasks.selectFile();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.upload),
                        onPressed: () {
                          tasks.uploadFileToTask(taskModel: widget.taskModel);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                tasks.file != null
                    ? basename(tasks.file!.path)
                    : 'No File Selected',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 5.0),
              if (widget.taskModel.attach != "")
                SizedBox(
                  width: 200,
                  child: InkWell(
                    onTap: () async {},
                    child: Row(
                      children: [
                        const Icon(Icons.download),
                        const SizedBox(width: 4.0),
                        Text(
                          tasks.getFileName(widget.taskModel.attach!),
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .45,
                child: ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => SizedBox(
                          height: 10,
                        ),
                    itemCount: tasks.allUserInTask.length,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.5),
                          color: Theme.of(context).primaryColorLight,
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                  tasks.allUserInTask[index].image ?? ""),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${tasks.allUserInTask[index].fName} ${tasks.allUserInTask[index].lName}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    tasks.allUserInTask[index].email ?? "",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showAssignMemberPopup(BuildContext context, List<String> teamMembers) {
    // todo make teammembers of usermodel type
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Assigned Members'),
          content: Column(
            children: teamMembers
                .map((teamMembers) => ListTile(
                      title: Text(teamMembers),
                    ))
                .toList(),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Assign'),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
