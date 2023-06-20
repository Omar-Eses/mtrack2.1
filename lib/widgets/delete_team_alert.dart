import 'package:flutter/material.dart';

void showDeleteTeamConfirmation(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Are you sure you want to delete the team?'),
        actions: [
          TextButton(
            onPressed: () {
              // Perform delete action
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
        ],
      );
    },
  );
}
