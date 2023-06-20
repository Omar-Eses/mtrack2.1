import 'package:flutter/material.dart';
import 'package:mtrack/widgets/custom_member_card.dart';

class ViewTeamMembers extends StatelessWidget {
  const ViewTeamMembers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team members'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomMemberCard(
                name: 'Eyas',
                imageUrl: 'assets/images/profilemale.png',
                onEmailPressed: () {},
                onOptionsPressed: () {},
              ),
              const SizedBox(height: 7),
              CustomMemberCard(
                name: 'Eyas',
                imageUrl: 'assets/images/profilemale.png',
                onEmailPressed: () {},
                onOptionsPressed: () {},
              ),
              const SizedBox(height: 7),
              CustomMemberCard(
                name: 'Eyas',
                imageUrl: 'assets/images/profilemale.png',
                onEmailPressed: () {},
                onOptionsPressed: () {},
              ),
            ],
          ),
        ),
      ), //todo be replaced with Listview.builder
    );
  }
}
