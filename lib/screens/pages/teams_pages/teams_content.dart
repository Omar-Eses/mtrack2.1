import 'package:flutter/material.dart';
import 'package:mtrack/provider/team_view_model.dart';
import 'package:mtrack/screens/pages/teams_pages/team_screen.dart';
import 'package:mtrack/widgets/custom_team_card.dart';
import 'package:mtrack/widgets/custom_txt_field.dart';
import 'package:provider/provider.dart';

class TeamsContent extends StatefulWidget {
  const TeamsContent({Key? key}) : super(key: key);

  @override
  State<TeamsContent> createState() => TeamsContentState();
}

class TeamsContentState extends State<TeamsContent> {
  @override
  void initState() {
    Future.microtask(() => context.read<TeamViewModel>().readTeams());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const CustomTextField(
            labelTxt: 'Search for Team',
            width: 375,
            fixedIcon: Icons.search_outlined,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Consumer<TeamViewModel>(
              builder: (context, teamViewModel, child) {
                if (teamViewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (teamViewModel.teamModelList.isEmpty) {
                  return const Center(child: Text('No teams found.'));
                } else {
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final team = teamViewModel.teamModelList[index];
                      return CustomTeamCard(
                        teamName: team.name!,
                        teamBio: team.desc ?? "",
                        peopleInTeam: team.members ?? [],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TeamScreen(
                                teamModel: team,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    itemCount: teamViewModel.teamModelList.length,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
