import 'package:flutter/material.dart';

import '../../widgets/custom_notification.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<CustomNotification> notifications = const [
    CustomNotification(
      accountLogo: 'assets/images/profilemale.png',
      personName: 'John Doe',
      action: 'Added a new task',
    ),
    CustomNotification(
      accountLogo: 'assets/images/profilemale.png',
      personName: 'Jane Smith',
      action: 'Completed a task',
    ),
    // Add more notifications as needed
  ];

  Future refresh() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: ListView.builder(
          itemCount: 2,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return CustomNotification(
              accountLogo: notification.accountLogo,
              personName: notification.personName,
              action: notification.action,
              // now it should go to the specific notification task
            );
          },
        ),
      ),
    );
  }
}
