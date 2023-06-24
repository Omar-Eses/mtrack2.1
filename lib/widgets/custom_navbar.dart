import 'package:flutter/material.dart';

class CustomNavBar extends StatefulWidget {
  final int currentPageIndex;
  const CustomNavBar({
    super.key,
    required this.currentPageIndex,
  });

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  String currentPageString = '/home';

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      height: 60,
      selectedIndex: widget.currentPageIndex,
      onDestinationSelected: (int index) {
        switch (index) {
          case 0:
            widget.currentPageIndex == index ? null : currentPageString = '/';
            break;
          case 1:
            widget.currentPageIndex == index
                ? null
                : currentPageString = '/teams';
            break;
          case 2:
            widget.currentPageIndex == index
                ? null
                : currentPageString = '/profile';
            break;
          default:
            widget.currentPageIndex == index;
            break;
        }
        // setState(() {
        //   widget.currentPageIndex = index;
        //   currentPageString = '$currentPageString';
        // });
        // Navigator.pop(context);
        // Navigator.pushNamed(context, '/');
        Navigator.pushNamed(context, currentPageString);
      },
      destinations: const <Widget>[
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.people_alt_outlined),
          label: 'Teams',
        ),
        NavigationDestination(
          icon: Icon(Icons.account_circle_outlined),
          label: 'Profile',
        ),
      ],
    );
  }
}
