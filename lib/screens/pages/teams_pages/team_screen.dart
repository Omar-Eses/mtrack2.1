import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_octicons/flutter_octicons.dart';
import 'package:mtrack/provider/task_view_model.dart';
import 'package:mtrack/provider/team_view_model.dart';
import 'package:mtrack/screens/pages/teams_pages/add_member.dart';
import 'package:mtrack/screens/pages/teams_pages/project.dart';
import 'package:mtrack/screens/pages/teams_pages/task_related/create_task_form.dart';
import 'package:mtrack/screens/pages/teams_pages/task_related/task_screen.dart';
import 'package:provider/provider.dart';

import '../../../models/team_model.dart';

class TeamScreen extends StatefulWidget {
  final TeamModel teamModel;
  const TeamScreen({super.key, required this.teamModel});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  @override
  void initState() {
    Future.microtask(() =>
        context.read<TaskViewModel>().getAllTasks(widget.teamModel.tasks!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final team = context.watch<TeamViewModel>();
    final bool isAdmin = team.isAdmin;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.teamModel.name!,
        ),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(padding: EdgeInsets.all(8)),
            Text(
              'Description',
            ),
            const SizedBox(height: 8),
            Text(widget.teamModel.desc!),
            const SizedBox(height: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 35,
                  child: Icon(
                    Icons.account_circle,
                    size: 35,
                  ),
                ),
                Text(
                  widget.teamModel.ownerName ?? '',
                ),
                const Text(
                  'Team Leader',
                ),
              ],
            ),
            Divider(
              thickness: 3,
              color: Theme.of(context).dividerColor,
            ),
            const SizedBox(height: 5),
            const Text('TASKS'),
            const SizedBox(height: 5),
            ElevatedButton(onPressed: () {}, child: Text("Leave")),
            Center(
              child: Visibility(
                visible: (widget.teamModel.tasks?.isEmpty ?? true),
                child: const Text(
                  'HOORAY... No tasks available',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Consumer<TaskViewModel>(
              builder: (context, taskViewModel, child) {
                if (taskViewModel.allTasks.isEmpty) {
                  return const Center(child: Text('No tasks found'));
                } else {
                  return SingleChildScrollView(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: taskViewModel.allTasks.length,
                      itemBuilder: (context, index) {
                        final task = taskViewModel.allTasks[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskScreen(
                                  task: task,
                                  teamModel: widget.teamModel,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            clipBehavior: Clip.hardEdge,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            color: Theme.of(context).cardColor,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        task.taskName ?? "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    task.taskDescription ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: isAdmin
          ? AdminFab(
              teamModel: widget.teamModel, members: widget.teamModel.members!)
          : MemberFab(
              teamModel: widget.teamModel, members: widget.teamModel.members!),
    );
  }
}

class AdminFab extends StatelessWidget {
  final TeamModel teamModel;
  final List members;
  const AdminFab({super.key, required this.teamModel, required this.members});

  @override
  Widget build(BuildContext context) {
    final _key = GlobalKey<ExpandableFabState>();
    final team = context.watch<TeamViewModel>();
    return ExpandableFab(
      key: _key,
      duration: const Duration(milliseconds: 500),
      distance: 150,
      children: [
        FloatingActionButton(
          heroTag: null,
          child: const Icon(Icons.add_task_outlined),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateTaskForm(
                  members: members,
                  teamModel: teamModel,
                ),
              ),
            );
          },
        ),
        FloatingActionButton(
          heroTag: null,
          child: const Icon(OctIcons.project_roadmap_16),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ProjectPlanScreen()),
            );
          },
        ),
        FloatingActionButton(
          heroTag: null,
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddMember(teamId: teamModel.teamId),
              ),
            );
          },
        ),
        FloatingActionButton(
          heroTag: null,
          child: const Icon(Icons.manage_accounts_outlined),
          onPressed: () {},
        ),
      ],
    );
  }
}

class MemberFab extends StatelessWidget {
  final TeamModel teamModel;
  final List members;
  const MemberFab({super.key, required this.teamModel, required this.members});

  @override
  Widget build(BuildContext context) {
    final team = context.watch<TeamViewModel>();
    return ExpandableFab(
      duration: const Duration(milliseconds: 500),
      distance: 75,
      children: [
        FloatingActionButton.extended(
          heroTag: null,
          icon: const Icon(Icons.add_task_outlined),
          label: const Text('Add Task'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreateTaskForm(
                  members: members,
                  teamModel: teamModel,
                ),
              ),
            );
          },
        ),
        FloatingActionButton.extended(
          heroTag: null,
          icon: const Icon(Icons.remove_red_eye_outlined),
          label: const Text('View Memebers'),
          onPressed: () {
            Navigator.popAndPushNamed(context, '/view_team_members');
          },
        ),
      ],
    );
  }
}
