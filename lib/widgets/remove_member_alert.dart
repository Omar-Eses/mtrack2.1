import 'package:flutter/material.dart';

void showRemoveMemberConfirmation(BuildContext context, String memberName) {
  // todo string membername to be changed to usermodel object
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmation'),
        content:
            Text('Are you sure you want to remove $memberName from the team?'),
        actions: [
          TextButton(
            onPressed: () {
              // Perform remove member action
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
