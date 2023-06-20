import 'package:flutter/material.dart';
import 'package:mtrack/provider/auth_view_model.dart';
import 'package:mtrack/widgets/custom_btn.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Image.asset(
            'assets/images/settings.png',
            height: 150,
          ),
          const SizedBox(height: 16.0),
          CustomButton(
            text: 'Terms and Conditions',
            onPressed: () {
              // TODO: Implement Terms and Conditions action
            },
          ),
          const SizedBox(height: 16.0),
          CustomButton(
            text: 'Security & Privacy Policy',
            onPressed: () {
              // TODO: Implement Security & Privacy Policy action
            },
          ),
          const SizedBox(height: 16.0),
          CustomButton(
            text: 'About Us',
            onPressed: () {
              // TODO: Implement About Us action
            },
          ),
          const SizedBox(height: 16.0),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(
                  width: 2.0, color: Colors.red), // Set border properties
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0), // Set border radius
              ),
            ),
            onPressed: () async {
              _showDeleteAccountConfirmation(context);
            },
            child: const Text(
              'Delete Account',
              style: TextStyle(
                color: Colors.red, // Set text color to red
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountConfirmation(BuildContext context) {
    final delete = context.watch<AuthViewModel>();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text('Are you sure you want to delete your account?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await delete.deleteUser();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/signup',
                  (route) => false,
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
