import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mtrack/models/team_model.dart';
import 'package:mtrack/provider/team_view_model.dart';
import 'package:provider/provider.dart';

class ManageTeamMembers extends StatefulWidget {
  final TeamModel teamModel;
  const ManageTeamMembers({Key? key, required this.teamModel})
      : super(key: key);

  @override
  State<ManageTeamMembers> createState() => _ManageTeamMembersState();
}

class _ManageTeamMembersState extends State<ManageTeamMembers> {
  @override
  void initState() {
    Future.microtask(() =>
        context.read<TeamViewModel>().getTeamMember(widget.teamModel.teamId!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final team = context.watch<TeamViewModel>();
    print(widget.teamModel.owner);
    print(FirebaseAuth.instance.currentUser!.email);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Team'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
                  height: 10,
                ),
            itemCount: team.teamMember.length,
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
                          NetworkImage(team.teamMember[index].image ?? ""),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${team.teamMember[index].fName} ${team.teamMember[index].lName}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            team.teamMember[index].email ?? "",
                          ),
                        ],
                      ),
                    ),
                    widget.teamModel.owner ==
                            FirebaseAuth.instance.currentUser!.email
                        ? IconButton(
                            onPressed: () {
                              team.deleteTeamMember(
                                  teamId: widget.teamModel.teamId!,
                                  email: team.teamMember[index].email!);
                            },
                            icon: const Icon(Icons.delete),
                          )
                        : SizedBox(),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
