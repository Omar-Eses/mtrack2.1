import 'package:flutter/material.dart';
import 'package:mtrack/provider/add_member_view_model.dart';
import 'package:mtrack/widgets/custom_txt_form_field.dart';
import 'package:provider/provider.dart';

import '../../../widgets/add_user_widget.dart';

class AddMember extends StatefulWidget {
  final String? teamId;
  const AddMember({Key? key, this.teamId}) : super(key: key);

  @override
  State<AddMember> createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  @override
  void initState() {
    /*Future.microtask(
        () => context.read<AddMemberViewModel>().getMemberUser(widget.teamId!));*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.teamId);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.popAndPushNamed(context, '/teams');
          },
          icon: const Icon(Icons.cancel_outlined),
        ),
        title: const Text('Add members'),
        actions: [
          IconButton(
              onPressed: () {
                // it has to save the added people as well then send the form
                // even if user didn't enter any it will pop to
                Navigator.popAndPushNamed(context, '/teams');
              },
              icon: const Icon(Icons.check_outlined))
        ],
      ),
      body: AddMemberForm(
        teamId: widget.teamId!,
      ),
    );
  }
}

class AddMemberForm extends StatefulWidget {
  final String teamId;
  const AddMemberForm({Key? key, required this.teamId}) : super(key: key);

  @override
  State<AddMemberForm> createState() => _AddMemberFormState();
}

class _AddMemberFormState extends State<AddMemberForm> {
  List<String>? result;
  @override
  Widget build(BuildContext context) {
    final addMember = context.watch<AddMemberViewModel>();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomTextFormField(
            labelTxt: 'Enter user name or email',
            fixedIcon: Icons.search_outlined,
            height: 30,
            controller: addMember.search,
            onFieldSubmitted: (_) {
              addMember.searchUser();
              print(addMember.users);
            },
          ),
          ElevatedButton(
            onPressed: () {
              addMember.clearSearch();
            },
            child: const Text("Clear"),
          ),
          Expanded(
            child: Builder(
              builder: (context) => ListView.separated(
                itemCount: addMember.users.length,
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
                itemBuilder: (context, index) {
                  final user = addMember.users[index];
                  return UserWidget(
                    name: user.fName ?? "",
                    email: user.email ?? "",
                    imageUrl: user.image ?? "",
                    onPressed: () {
                      addMember.addUserToTeam(
                        teamId: widget.teamId,
                        userAdd: user,
                      );
                    }, // Replace this with the logic to determine if the user is added or not
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
