import 'package:flutter/material.dart';

AppBar customAppBar(BuildContext context, String pageTitle) {
  return AppBar(
    elevation: 0,
    leading: Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset('assets/images/profilemale.png'),
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer(); // Open the drawer
          },
        );
      },
    ),
    title: Text(pageTitle),
  );
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String pageTitle;
  final String userPhotoUrl;
  final VoidCallback onNotificationPressed;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  const CustomAppBar({
    Key? key,
    required this.pageTitle,
    required this.userPhotoUrl,
    required this.onNotificationPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: Builder(builder: (context) {
        return Drawer(
          backgroundColor: Theme.of(context).colorScheme.background,
          child: IconButton(
            icon: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(userPhotoUrl),
            ),
            onPressed: () {
              // shows side bar
              Scaffold.of(context).openDrawer();
            },
          ),
        );
      }),
      title: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          Text(pageTitle),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications),
        )
      ],
    );
  }
}
