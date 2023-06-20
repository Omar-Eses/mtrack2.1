import 'package:flutter/material.dart';
import 'package:mtrack/widgets/custom_appbar.dart';
import 'package:mtrack/widgets/custom_navbar.dart';
import 'package:mtrack/widgets/profile_screen/profile_content.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, 'Tasks'),
      body: const ProfileCgit ontent(),
      bottomNavigationBar: const CustomNavBar(currentPageIndex: 2),
    );
  }
}
