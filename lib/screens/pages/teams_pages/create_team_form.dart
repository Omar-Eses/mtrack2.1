import 'package:flutter/material.dart';
import 'package:mtrack/provider/home_view_model.dart';
import 'package:mtrack/provider/team_view_model.dart';
import 'package:mtrack/widgets/custom_btn.dart';
import 'package:mtrack/widgets/custom_txt_form_field.dart';
import 'package:provider/provider.dart';

class CreateTeamForm extends StatelessWidget {
  const CreateTeamForm({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final newTeam = context.watch<TeamViewModel>();
    final home = context.watch<HomeViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Team'),
        actions: [
          IconButton(
            onPressed: () async {
              if (newTeam.teamFormKey.currentState != null &&
                  newTeam.teamFormKey.currentState!.validate()) {
                await newTeam.registerTeam(
                  context: context,
                  fName: home.userModel?.fName ?? "",
                  lName: home.userModel?.lName ?? "",
                );
              }
            },
            icon: const Icon(Icons.check_outlined),
          ),
        ],
      ),
      body: Form(
        key: newTeam.teamFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextFormField(
              labelTxt: 'Team Name',
              fixedIcon: Icons.account_circle_outlined,
              controller: newTeam.teamName,
              validator: (value) {
                if (value!.isEmpty) {
                  return "team name is required";
                } else if (value.length > 20) {
                  return "team name is too long";
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            CustomTextFormField(
              labelTxt: 'Team Description up to 200 letters',
              fixedIcon: Icons.description_outlined,
              controller: newTeam.teamDescription,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Create',
              icon: Icons.check_outlined,
              width: 150,
              onPressed: () async {
                // Navigator.of(context).pushNamed('/add_member');
                if (newTeam.teamFormKey.currentState!.validate()) {
                  await newTeam.registerTeam(
                    context: context,
                    fName: home.userModel?.fName ?? "",
                    lName: home.userModel?.lName ?? "",
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
