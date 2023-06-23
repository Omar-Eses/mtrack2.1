import 'package:flutter/material.dart';
import 'package:mtrack/models/task_model.dart';
import 'package:mtrack/models/team_model.dart';
import 'package:mtrack/provider/assign_view_model.dart';
import 'package:provider/provider.dart';

class AssignUserScreen extends StatefulWidget {
  final TeamModel teamModel;
  final TaskModel taskModel;
  const AssignUserScreen(
      {Key? key, required this.teamModel, required this.taskModel})
      : super(key: key);

  @override
  State<AssignUserScreen> createState() => _AssignUserScreenState();
}

class _AssignUserScreenState extends State<AssignUserScreen> {
  @override
  void initState() {
    Future.microtask(() => context
        .read<AssignViewModel>()
        .getAllUserInTeam(widget.teamModel.teamId!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final assign = context.watch<AssignViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
                  height: 10,
                ),
            itemCount: assign.allUsers.length,
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
                      backgroundImage:
                          NetworkImage(assign.allUsers[index].image ?? ""),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${assign.allUsers[index].fName} ${assign.allUsers[index].lName}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            assign.allUsers[index].email ?? "",
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        assign.assignUser(
                            taskModel: widget.taskModel,
                            userModel: assign.allUsers[index]);
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
