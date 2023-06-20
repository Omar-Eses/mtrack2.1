import 'package:flutter/material.dart';

class CustomTeamCard extends StatelessWidget {
  const CustomTeamCard({
    Key? key,
    required this.teamName,
    required this.teamBio,
    required this.peopleInTeam,
    required this.onTap,
  }) : super(key: key);

  final String teamName;
  final String teamBio;
  final List peopleInTeam;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    teamName,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                teamBio,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 10),
              // Row(
              //   children: peopleInTeam
              //       .map((person) =>
              //           CircleAvatar(child: Text(person.substring(0, 1))))
              //       .toList(),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
