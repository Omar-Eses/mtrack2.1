import 'package:flutter/material.dart';

class CustomMemberCard extends StatelessWidget {
  const CustomMemberCard({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.onEmailPressed,
    required this.onOptionsPressed,
  }) : super(key: key);

  final String name;
  final String imageUrl;
  final VoidCallback onEmailPressed;
  final VoidCallback onOptionsPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).primaryColorLight),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('assets/images/profilemale.png'),
          ),
          const SizedBox(width: 15),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.email),
            onPressed: onEmailPressed,
          ),
        ],
      ),
    );
  }
}

class CustomMemberCardAdmin extends StatelessWidget {
  const CustomMemberCardAdmin(
      {Key? key,
      required this.name,
      required this.imageUrl,
      required this.onEmailPressed,
      required this.onOptionsPressed})
      : super(key: key);

  final String name;
  final String imageUrl;
  final VoidCallback onEmailPressed;
  final VoidCallback onOptionsPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).primaryColorLight),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage('assets/images/profilemale.png'),
          ),
          const SizedBox(width: 15),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.email),
            onPressed: onEmailPressed,
          ),
          const Spacer(),
          PopupMenuButton(
            child: const Center(child: Icon(Icons.more_vert_outlined)),
            itemBuilder: (context) {
              return List.generate(2, (index) {
                return PopupMenuItem(
                  child: Text('button no ${index + 1}'),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}
