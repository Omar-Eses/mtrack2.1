import 'package:flutter/material.dart';
import 'package:mtrack/screens/pages/teams_pages/teams_content.dart';
import 'package:mtrack/widgets/custom_appbar.dart';
import 'package:mtrack/widgets/custom_navbar.dart';

// ignore: must_be_immutable
class TeamsScreen extends StatelessWidget {
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  // final _formKey = GlobalKey<FormState>();

  TeamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: customAppBar(context, 'Teams'),
      body: TeamsContent(),
      bottomNavigationBar: const CustomNavBar(currentPageIndex: 1),
      floatingActionButton: FloatingActionButton(
        splashColor: Theme.of(context).focusColor,
        onPressed: () {
          // Add action for the Home screen FloatingActionButton
          Navigator.of(context).pushNamed('/new_team');
        },
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}
